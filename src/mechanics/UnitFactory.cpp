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

#include "UnitFactory.h"
#include "resource/DataManager.h"
#include "core/Constants.h"
#include "Farm.h"
#include "Civilization.h"
#include "Building.h"
#include "UnitManager.h"
#include "Player.h"
#include "actions/ActionFly.h"

#include <genie/dat/Unit.h>


UnitFactory &UnitFactory::Inst()
{
    static UnitFactory inst;
    return inst;
}

UnitFactory::UnitFactory()
{
}

UnitFactory::~UnitFactory()
{
}

void UnitFactory::handleDefaultAction(const Unit::Ptr &unit, const genie::Task &task)
{
    switch(task.ActionType) {
    case genie::Task::Fly: {
        MapPos flyingPosition = unit->position();
        DBG << "Flying unit at" << flyingPosition;
        // Castles are 4 high, so set 5.5 just to be safe that we fly above everything
        if (flyingPosition.z < 10) {
            flyingPosition.z = 10;
            unit->setPosition(flyingPosition);
        }
        unit->setCurrentAction(std::make_shared<ActionFly>(unit, Task(task, unit->data()->ID)));
        break;
    }

        //TODO
    case genie::Task::Graze:
    case genie::Task::GetAutoConverted:
        break;
    default:
        WARN << "unhandled default action" << task.actionTypeName();
    }

}

Unit::Ptr UnitFactory::createUnit(const int ID, const MapPos &position, const Player::Ptr &owner, UnitManager &unitManager)
{
    const genie::Unit &gunit = owner->civilization.unitData(ID);
    owner->applyResearch(gunit.Building.TechID);

    Unit::Ptr unit;
    if (ID == Unit::Farm) {
        unit = std::make_shared<Farm>(gunit, owner, unitManager);
    } else if (gunit.Type == genie::Unit::BuildingType) {
        unit = std::make_shared<Building>(gunit, owner, unitManager);
    } else {
        unit = std::make_shared<Unit>(gunit, owner, unitManager);
    }


    for (const genie::Unit::ResourceStorage &res : gunit.ResourceStorages) {
        if (res.Type == -1) {
            continue;
        }

        unit->resources[genie::ResourceType(res.Type)] = res.Amount;
    }

    if (gunit.Class == genie::Unit::Farm) {
        unit->resources[genie::ResourceType::FoodStorage] = owner->civilization.startingResource(genie::ResourceType::FarmFoodAmount);

    }

    if (gunit.Type >= genie::Unit::BuildingType) {
        unit->snapPositionToGrid();

        if (gunit.Building.StackUnitID >= 0) {
            const genie::Unit &stackData = owner->civilization.unitData(gunit.Building.StackUnitID);
            owner->applyResearch(gunit.Building.TechID);

            Unit::Annex annex;
            annex.unit = std::make_shared<Unit>(stackData, owner, unitManager);
            unit->annexes.push_back(annex);
        }

        for (const genie::unit::BuildingAnnex &annexData : gunit.Building.Annexes) {
            if (annexData.UnitID < 0) {
                continue;
            }
            const genie::Unit &gunit = owner->civilization.unitData(annexData.UnitID);
            owner->applyResearch(gunit.Building.TechID);

            Unit::Annex annex;
            annex.offset = MapPos(annexData.Misplacement.first * -48, annexData.Misplacement.second * -48);
            annex.unit = std::make_shared<Unit>(gunit, owner, unitManager);
            unit->annexes.push_back(annex);
        }

        if (!unit->annexes.empty()) {
            std::reverse(unit->annexes.begin(), unit->annexes.end());
        }
    }

    unit->setPosition(position, true);

    const std::vector<genie::Task>  &taskList = DataManager::Inst().getTasks(ID);
    if (gunit.Action.DefaultTaskID >= 0 && gunit.Action.DefaultTaskID < taskList.size()) {
        handleDefaultAction(unit, taskList[gunit.Action.DefaultTaskID]);
    } else {
        for (const genie::Task &task : taskList) {
            if (task.IsDefault) {
                handleDefaultAction(unit, task);
                break;
            }
        }
    }

    return unit;
}

DecayingEntity::Ptr UnitFactory::createCorpseFor(const Unit::Ptr &unit)
{
    if (IS_UNLIKELY(!unit)) {
        WARN << "can't create corpse for null unit";
        return nullptr;
    }

    Player::Ptr owner = unit->player.lock();
    if (!owner) {
        WARN << "no owner for corpse";
        return nullptr;
    }

    if (unit->data()->DeadUnitID == -1) {
        return nullptr;
    }

    const genie::Unit &corpseData = owner->civilization.unitData(unit->data()->DeadUnitID);
    float decayTime = corpseData.ResourceDecay * corpseData.ResourceCapacity;

    for (const genie::Unit::ResourceStorage &r : corpseData.ResourceStorages) {
        if (r.Type == int(genie::ResourceType::CorpseDecayTime)) {
            decayTime = r.Amount;
            break;
        }
    }

    // I don't think this is really correct, but it works better
    if (corpseData.ResourceDecay == -1 || (corpseData.ResourceDecay != 0 && corpseData.ResourceCapacity == 0)) {
        DBG << "decaying forever";
        decayTime = std::numeric_limits<float>::infinity();
    }
    DecayingEntity::Ptr corpse = std::make_shared<DecayingEntity>(corpseData.StandingGraphic.first, decayTime);
    corpse->renderer().setPlayerColor(owner->playerColor);
    corpse->setPosition(unit->position());
    corpse->renderer().setAngle(unit->angle());
    corpse->setMap(unit->map());

    return corpse;

}
