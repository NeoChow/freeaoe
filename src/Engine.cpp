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


#include "Engine.h"

#include <sstream>

#include <SFML/Graphics.hpp>

#include <SFML/Graphics/RenderWindow.hpp>
#include "render/SfmlRenderTarget.h"
#include "resource/AssetManager.h"
#include "resource/Resource.h"
#include "render/GraphicRender.h"
#include "global/Config.h"
#include <genie/resource/SlpFile.h>
#include <genie/resource/UIFile.h>

const sf::Clock Engine::GameClock;


//------------------------------------------------------------------------------
Engine::Engine()
{

}

//------------------------------------------------------------------------------
Engine::~Engine()
{
  DBG << "Closing engine";
}

//------------------------------------------------------------------------------
void Engine::start()
{
    DBG << "Starting engine.";

    // Start the game loop
    while (renderWindow_->isOpen()) {
        std::shared_ptr<GameState> state = state_manager_.getActiveState();

        const int renderStart = GameClock.getElapsedTime().asMilliseconds();

        bool updated = false;

        // Process events
        sf::Event event;
        while (renderWindow_->pollEvent(event)) {
            // Close window : exit
            if (event.type == sf::Event::Closed) {
                renderWindow_->close();
            }

            if (event.type == sf::Event::MouseButtonPressed || event.type == sf::Event::MouseButtonReleased) {
                sf::Vector2f mappedPos = renderWindow_->mapPixelToCoords(sf::Vector2i(event.mouseButton.x, event.mouseButton.y));
                event.mouseButton.x = mappedPos.x;
                event.mouseButton.y = mappedPos.y;
            }

            if (event.type == sf::Event::MouseMoved) {
                sf::Vector2f mappedPos = renderWindow_->mapPixelToCoords(sf::Vector2i(event.mouseMove.x, event.mouseMove.y));
                event.mouseMove.x = mappedPos.x;
                event.mouseMove.y = mappedPos.y;
            }

            if (!handleEvent(event)) {
                state->handleEvent(event);
            }

            updated = true;
        }

        updated = state->update(GameClock.getElapsedTime().asMilliseconds()) || updated;

        if (updated) {
            // Clear screen
            renderWindow_->clear(sf::Color::Green);
            state->draw();
            drawButtons();
            const int renderTime = GameClock.getElapsedTime().asMilliseconds() - renderStart;

            if (renderTime > 0) {
                fps_label_.setString("fps: " + std::to_string(1000/renderTime));
            }

            renderWindow_->draw(fps_label_);

            // Update the window
            renderWindow_->display();
        } else {
            sf::sleep(sf::milliseconds(1000 / 60));
        }

    }
}

void Engine::showStartScreen()
{
    genie::UIFilePtr uiFile = AssetManager::Inst()->getUIFile("scrstart.sin");
    if (!uiFile) {
        WARN << "failed to load ui file for start screen";
        return;
    }

    genie::SlpFilePtr loadingImageFile = AssetManager::Inst()->getSlp(uiFile->backgroundSmall.fileId);
    if (!loadingImageFile) {
        WARN << "Failed to load background for start screen" << uiFile->backgroundSmall.filename << uiFile->backgroundSmall.alternateFilename;
        return;
    }

    sf::Texture loadingScreen;
    loadingScreen.loadFromImage(Resource::convertFrameToImage(
                                    loadingImageFile->getFrame(0),
                                    AssetManager::Inst()->getPalette(uiFile->paletteFile.id)
                                    ));

    sf::Sprite sprite;
    sprite.setTexture(loadingScreen);
    sprite.setPosition(0, 0);
    sprite.setScale(renderWindow_->getSize().x / float(loadingScreen.getSize().x),
                    renderWindow_->getSize().y / float(loadingScreen.getSize().y));
    renderTarget_->draw(sprite);
    renderWindow_->display();
}

void Engine::loadTopButtons()
{
    genie::SlpFilePtr buttonsFile = AssetManager::Inst()->getSlp("btngame2x.shp");
    if (!buttonsFile) {
        WARN << "Failed to load SLP for buttons";
        return;
    }

    if (buttonsFile->getFrameCount() < TopMenuButton::ButtonsCount * 2) {
        WARN << "Not enough buttons";
    }

    int x = renderWindow_->getSize().x - 5;
    for (int i=0; i<TopMenuButton::ButtonsCount; i++) {
        TopMenuButton button;
        button.type = TopMenuButton::Type(i);

        button.texture.loadFromImage(Resource::convertFrameToImage(buttonsFile->getFrame(i * 2)));
        button.pressedTexture.loadFromImage(Resource::convertFrameToImage(buttonsFile->getFrame(i * 2 + 1)));

        button.rect.setSize(button.texture.getSize());
        x -= button.rect.width;

        button.rect.x = x;
        button.rect.y = 5;

        m_buttons.push_back(std::move(button));
    }
}

void Engine::drawButtons()
{
    for (const TopMenuButton &button : m_buttons) {
        sf::Sprite sprite;
        if (button.type == m_pressedButton) {
            sprite.setTexture(button.pressedTexture);
        } else {
            sprite.setTexture(button.texture);
        }

        sprite.setPosition(button.rect.topLeft());
        renderWindow_->draw(sprite);
    }
}

bool Engine::handleEvent(sf::Event event)
{
    if (event.type == sf::Event::MouseButtonReleased) {
        if (m_pressedButton != TopMenuButton::Invalid) {
            m_pressedButton = TopMenuButton::Invalid;
            return true;
        }

        return false;
    }

    if (event.type != sf::Event::MouseButtonPressed) {
        return false;
    }
    const ScreenPos mousePos(event.mouseButton.x, event.mouseButton.y);
    for (const TopMenuButton &button : m_buttons) {
        if (button.rect.contains(mousePos)) {
            m_pressedButton = button.type;
            return true;
        }
    }

    return false;
}

//------------------------------------------------------------------------------
bool Engine::setup(const std::shared_ptr<genie::ScnFile> &scenario)
{
    renderWindow_ = std::make_unique<sf::RenderWindow>(sf::VideoMode(1280, 1024), "freeaoe", sf::Style::None);
    renderWindow_->setMouseCursorVisible(false);
    renderWindow_->setFramerateLimit(60);

    renderTarget_ = std::make_shared<SfmlRenderTarget>(*renderWindow_);

    showStartScreen();

    std::shared_ptr<GameState> gameState = std::make_shared<GameState>(renderTarget_);
    if (scenario) {
        gameState->setScenario(scenario);
    }

    if (!state_manager_.addActiveState(gameState)) {
        return false;
    }

    renderWindow_->setSize(gameState->uiSize());
    renderTarget_->setSize(gameState->uiSize());

    fps_label_.setPosition(sf::Vector2f(gameState->uiSize().width - 75, gameState->uiSize().height - 20));
    fps_label_.setFillColor(sf::Color::White);
    fps_label_.setFont(SfmlRenderTarget::defaultFont());
    fps_label_.setCharacterSize(15);

    loadTopButtons();

    return true;
}
