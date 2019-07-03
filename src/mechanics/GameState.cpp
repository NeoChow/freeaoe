/*
    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) 2011  <copyright holder> <email>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "GameState.h"

#include <genie/resource/Color.h>

#include <SFML/Graphics/RenderTarget.hpp>
#include <SFML/Window/Mouse.hpp>
#include <communication/commands/CommandSpawn.h>
#include <server/GameServer.h>
#include <client/GameClient.h>
#include <communication/tunnels/LocalTunnelToServer.h>
#include <communication/tunnels/LocalTunnelToClient.h>

#include <iostream>
#include <render/GraphicRender.h>
#include "UnitFactory.h"
#include <Engine.h>
#include "render/MapRenderer.h"
#include "render/SfmlRenderTarget.h"
#include "resource/DataManager.h"
#include "ui/ActionPanel.h"
#include "ui/UnitInfoPanel.h"
#include "core/Constants.h"
#include "debug/SampleGameFactory.h"
#include "mechanics/UnitManager.h"

#include "resource/LanguageManager.h"

std::unordered_map<GameType, ResourceMap> GameState::defaultStartingResources = {
    {
        GameType::Default, {
            { genie::ResourceType::FoodStorage, 500 },
            { genie::ResourceType::WoodStorage, 500 },
            { genie::ResourceType::StoneStorage, 500 },
            { genie::ResourceType::GoldStorage, 500 },
        }
    },
    {
        GameType::HighResource, {
            { genie::ResourceType::FoodStorage, 1000 },
            { genie::ResourceType::WoodStorage, 1000 },
            { genie::ResourceType::StoneStorage, 800 },
            { genie::ResourceType::GoldStorage, 700 },
        }
    },
    {
        GameType::MediumResource, {
            { genie::ResourceType::FoodStorage, 500 },
            { genie::ResourceType::WoodStorage, 500 },
            { genie::ResourceType::StoneStorage, 400 },
            { genie::ResourceType::GoldStorage, 300 },
        }
    },
    {
        GameType::KingOfTheHill, {
            { genie::ResourceType::FoodStorage, 200 },
            { genie::ResourceType::WoodStorage, 200 },
            { genie::ResourceType::StoneStorage, 200 },
            { genie::ResourceType::GoldStorage, 100 },
        }
    },
    {
        GameType::Deathmatch, {
            { genie::ResourceType::FoodStorage, 20000 },
            { genie::ResourceType::WoodStorage, 20000 },
            { genie::ResourceType::StoneStorage, 5000 },
            { genie::ResourceType::GoldStorage, 10000 },
        }
    },
    {
        GameType::Regicide, {
            { genie::ResourceType::FoodStorage, 500 },
            { genie::ResourceType::WoodStorage, 500 },
            { genie::ResourceType::StoneStorage, 150 },
            { genie::ResourceType::GoldStorage, 0 },
        }
    },
};

GameState::GameState(const std::shared_ptr<SfmlRenderTarget> &renderTarget)
{
    m_unitManager = std::make_shared<UnitManager>();
    renderTarget_ = renderTarget;

    m_actionPanel = std::make_unique<ActionPanel>(renderTarget_);
    m_actionPanel->setUnitManager(m_unitManager);
    m_unitInfoPanel = std::make_unique<UnitInfoPanel>(renderTarget_);
    m_unitInfoPanel->setUnitManager(m_unitManager);
}

GameState::~GameState()
{
}

void GameState::setScenario(const std::shared_ptr<genie::ScnFile> &scenario)
{
    scenario_ = scenario;
}

bool GameState::init()
{
    TIME_THIS;
    if (!m_unitManager->init()) {
        return false;
    }

    if (!m_actionPanel->init()) {
        return false;
    }

    if (!m_unitInfoPanel->init()) {
        return false;
    }

    std::shared_ptr<genie::SlpFile> overlayFile = AssetManager::Inst()->getUiOverlay(AssetManager::Ui1280x1024, AssetManager::Viking);
    if (overlayFile) {
        m_uiOverlay.loadFromImage(Resource::convertFrameToImage(overlayFile->getFrame()));
        DBG << "Loaded UI overlay with size" << Size(m_uiOverlay.getSize());
    } else {
        AssetManager::UiResolution attemptedResolution = AssetManager::Ui1280x1024;
        AssetManager::UiCiv attemptedCiv = AssetManager::Briton;
        do {
            attemptedCiv = AssetManager::UiCiv(attemptedCiv + 1);
            if (attemptedCiv > AssetManager::Korean) {
                if (attemptedResolution == AssetManager::Ui1280x1024) {
                    attemptedResolution = AssetManager::Ui1024x768;
                } else if (attemptedResolution == AssetManager::Ui1024x768) {
                    attemptedResolution = AssetManager::Ui800x600;
                } else {
                    m_uiOverlay = sf::Texture();
                    break;
                }

                attemptedCiv = AssetManager::Briton;
            }
            overlayFile = AssetManager::Inst()->getUiOverlay(attemptedResolution, attemptedCiv);
        } while (!overlayFile);

        if (overlayFile) {
            WARN << "Loaded fallback ui overlay res" << attemptedResolution << "for civ" << attemptedCiv;
            m_uiOverlay.loadFromImage(Resource::convertFrameToImage(overlayFile->getFrame()));
        } else {
            WARN << "Failed to load ui overlay";
        }
    }

    // graphic 2962
    m_waypointFlag = AssetManager::Inst()->getSlp(3404);
    if (!m_waypointFlag) {
        WARN << "Failed to load waypoint animation";
    }

    const std::vector<genie::Civ> &civilizations = DataManager::Inst().civilizations();
    for (size_t i=0; i<civilizations.size(); i++) {
        m_civilizations.push_back(std::make_shared<Civilization>(i));
    }
    if (m_civilizations.empty()) {
        WARN << "Failed to load any civilizations";
        return false;
    }

    map_ = std::make_shared<Map>();
    m_unitManager->setMap(map_);

    if (scenario_) {
        setupScenario();
    } else {
        setupGame(GameType::Default);
    }

    m_actionPanel->setHumanPlayer(m_humanPlayer);
    m_unitManager->setHumanPlayer(m_humanPlayer);
    mapRenderer_.setVisibilityMap(m_humanPlayer->visibility);

    map_->updateMapData();
    mapRenderer_.setRenderTarget(renderTarget_);
    mapRenderer_.setMap(map_);

    return true;
}

void GameState::draw()
{
    mapRenderer_.display();

    std::vector<std::weak_ptr<Entity>> visibleEntities;
    visibleEntities = map_->entitiesBetween(mapRenderer_.firstVisibleColumn(),
                                            mapRenderer_.firstVisibleRow(),
                                            mapRenderer_.lastVisibleColumn(),
                                            mapRenderer_.lastVisibleRow());

    m_unitManager->render(renderTarget_, visibleEntities);

    if (m_selecting) {
        renderTarget_->draw(m_selectionRect, sf::Color::Transparent, sf::Color::White);
    }

    renderTarget_->draw(m_uiOverlay, ScreenPos(0, 0));
    m_actionPanel->draw();
    m_unitInfoPanel->draw();
}

bool GameState::update(Time time)
{
    bool updated = false;
    updated = mapRenderer_.update(time) || updated;

    updated = m_unitManager->update(time) || updated;
    updated = m_actionPanel->update(time) || updated;
    updated = m_unitInfoPanel->update(time) || updated;

    if (m_selecting) {
        ScreenRect selectionRect(m_selectionStart, m_selectionCurr);
        if (selectionRect != m_selectionRect) {
            m_selectionRect = selectionRect;
            updated = true;
        }
    }

    //game_server_->update();
    //game_client_->update();

    return updated;
}

bool GameState::handleEvent(sf::Event event)
{
    if (event.type != sf::Event::MouseButtonPressed && event.type != sf::Event::MouseButtonReleased) {
        return false;
    }

    const ScreenPos mousePos = ScreenPos(event.mouseButton.x, event.mouseButton.y);

    if (event.type != sf::Event::MouseButtonPressed && event.type != sf::Event::MouseButtonReleased) {
        return false;
    }

    if (m_actionPanel->rect().contains(mousePos)) {
        return m_actionPanel->handleEvent(event);
    }
    if (m_unitInfoPanel->rect().contains(mousePos)) {
        return m_unitInfoPanel->handleEvent(event);
    }

    m_actionPanel->releaseButtons();

    if (event.type == sf::Event::MouseButtonReleased) {
        if (event.mouseButton.button == sf::Mouse::Button::Left && m_selecting) {
        } else if (event.mouseButton.button == sf::Mouse::Button::Right) {
            m_unitManager->onRightClick(ScreenPos(event.mouseButton.x, event.mouseButton.y), renderTarget_->camera());
        }
    }

    return false;
}

Size GameState::uiSize() const
{
    if (m_uiOverlay.getSize().x == 0 || m_uiOverlay.getSize().y == 0) {
        WARN << "We don't have a valid UI overlay";
        return Size(640, 480);
    }

    return m_uiOverlay.getSize();
}

void GameState::onSelectionFinished()
{
    m_unitManager->selectUnits(m_selectionRect, renderTarget_->camera());
    m_selectionRect = ScreenRect();
    m_selecting = false;
}

void GameState::setupScenario()
{
    TIME_THIS;
    DBG << "Setting up scenario:" << scenario_->scenarioInstructions;
    map_->create(scenario_->map);

    const genie::ScnMainPlayerData &playerData = scenario_->playerData;
    for (size_t playerNum = 0; playerNum < scenario_->enabledPlayerCount; playerNum++) {
        Player::Ptr player;

        // player 0 is gaia
        if (playerNum != UnitManager::GaiaID) {
            player = std::make_shared<Player>(playerNum, m_civilizations[playerData.resourcesPlusPlayerInfo[playerNum-1].civilizationID]);
            player->name = playerData.playerNames[playerNum - 1];
        } else {
            player = std::make_shared<Player>(playerNum, m_civilizations[UnitManager::GaiaID]); // gaia
        }

        const genie::ScnPlayerResources &resources = scenario_->playerResources[playerNum];
        player->resourcesAvailable[genie::ResourceType::GoldStorage] = resources.gold;
        player->resourcesAvailable[genie::ResourceType::FoodStorage] = resources.food;
        player->resourcesAvailable[genie::ResourceType::WoodStorage] = resources.wood;
        player->resourcesAvailable[genie::ResourceType::StoneStorage] = resources.stone;
        player->resourcesAvailable[genie::ResourceType::OreStorage] = resources.ore;
        player->resourcesAvailable[genie::ResourceType::TradeGoods] = resources.goods;
        player->resourcesAvailable[genie::ResourceType::PopulationHeadroom] = scenario_->playerResources[playerNum].popLimit;

        m_players.push_back(player);
        for (const genie::ScnUnit &scnunit : scenario_->playerUnits[playerNum].units) {
            MapPos unitPos((scnunit.positionY) * Constants::TILE_SIZE, (scnunit.positionX) * Constants::TILE_SIZE, scnunit.positionZ * DataManager::Inst().terrainBlock().ElevHeight);
            Unit::Ptr unit = UnitFactory::Inst().createUnit(scnunit.objectID, unitPos, player, *m_unitManager);
            m_unitManager->add(unit);

            unit->setAngle(scnunit.rotation - M_PI_2/2.);

            if (unit->renderer().frameCount()) {
                unit->renderer().setCurrentFrame(scnunit.initAnimationFrame % unit->renderer().frameCount());
            } else {
//                WARN << "invalid graphics";
            }
        }
    }
    MapPos cameraPos;
    if (scenario_->playerData.player1CameraX >= 0 &&  scenario_->playerData.player1CameraX >= 0) {
        cameraPos = MapPos(scenario_->playerData.player1CameraX * Constants::TILE_SIZE, scenario_->playerData.player1CameraY * Constants::TILE_SIZE);
    } else {
        cameraPos = MapPos (scenario_->players[1].initCameraX * Constants::TILE_SIZE, map_->height() - scenario_->players[1].initCameraY * Constants::TILE_SIZE);
    }
    renderTarget_->camera()->setTargetPosition(cameraPos);
    m_humanPlayer = m_players[1];
}

void GameState::setupGame(const GameType /*gameType*/)
{
   SampleGamePtr sampleGameSetup = SampleGameFactory::Inst().createGameSetup(map_, m_unitManager);

   sampleGameSetup->setupMap();
   sampleGameSetup->setupActors(m_civilizations, defaultStartingResources[m_gameType]);

    m_humanPlayer = sampleGameSetup->getHumanPlayer();

    m_players.push_back(sampleGameSetup->getGaiaPlayer());
    m_players.push_back(m_humanPlayer);
    m_players.push_back(sampleGameSetup->getEnemyPlayer());

    MapPos cameraPos(map_->width() / 2, map_->height()  / 2);
    renderTarget_->camera()->setTargetPosition(cameraPos);
}
