/*
    Copyright (C) 2018 Martin Sandsmark <martin.sandsmark@kde.org>

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

#pragma once

#include "mechanics/Entity.h"
#include "core/ResourceMap.h"
#include "core/Constants.h"
#include "actions/IAction.h"

#include <deque>
#include <map>

#include <genie/dat/Unit.h>
#include <genie/dat/UnitCommand.h>
#include <genie/dat/unit/AttackOrArmor.h>

class Civilization;
struct Player;
struct Building;

namespace std {
template<> struct hash<Task>
{
    size_t operator()(const Task &b) const {
        return hash<int16_t>()(b.data->ID) ^ hash<uint16_t>()(b.unitId);
    }
};
}

struct Unit : public Entity
{
    enum HardcodedTypes {
        TownCenter = 109,

        FemaleVillager = 293,

        MaleVillager = 83,
        MaleLumberjack = 123,
        MaleStoneMiner = 124,
        MaleHunter = 122,
        MaleFarmer = 259,
        MaleForager = 120,
        MaleFisherman = 56,
        MaleGoldMiner = 579,
        MaleShepherd = 592,
        MaleBuilder = 118,
        MaleRepairer = 156,

        Docket = 45,
        Castle = 82,
        Market = 84,

        ArcheryRange = 87,
        Barracks = 12,
        Monastery = 104,
        SiegeWorkshop = 49,
        Stable = 101,

        Dock = 45,

        Mill = 68,
        LumberCamp = 562,
        MiningCamp = 584,

        PalisadeWall = 72,
        StoneWall = 117,
        FortifiedWall = 155,
        Gate = 487,

        Farm = 50,

        Cobra = 748,
        VMDL = 206,
        FuriousTheMonkeyBoy = 860,
    };

    typedef std::shared_ptr<Unit> Ptr;

    struct Annex {
        Unit::Ptr unit;
        MapPos offset;
    };

    enum class Stance {
        Aggressive,
        Defensive,
        StandGround,
        NoAttack
    } stance = Stance::Aggressive;

    // The blinking animation thing when it is selected as a target
    int targetBlinkTimeLeft = 0;

    Unit() = delete;
    Unit(const Unit &unit) = delete;

    Unit(const genie::Unit &data_, const std::shared_ptr<Player> &player_, UnitManager &unitManager);

    ~Unit();

    inline float angle() const noexcept { return m_renderer.angle(); }
    inline void setAngle(const float angle) noexcept { m_renderer.setAngle(angle); }

    void prependAction(const ActionPtr &action) noexcept;
    void queueAction(const ActionPtr &action) noexcept;
    void setCurrentAction(const ActionPtr &action) noexcept;
    void clearActionQueue() noexcept;
    const ActionPtr &currentAction() const noexcept { return m_currentAction; }

    void snapPositionToGrid() noexcept;

    bool update(Time time) noexcept override;

    const std::vector<const genie::Unit *> creatableUnits() noexcept;

    static std::shared_ptr<Building> asBuilding(const Unit::Ptr &unit) noexcept;

    bool selected = false;
    int playerId;
    std::weak_ptr<Player> player;
    std::vector<Annex> annexes;

    ResourceMap resources;

    virtual ScreenRect rect() const noexcept;
    virtual bool checkClick(const ScreenPos &pos) const noexcept;

    bool hasAutoTargets() const noexcept { return !m_autoTargetTasks.empty(); }
    void checkForAutoTargets() noexcept;
    std::unordered_set<Task> availableActions() noexcept;
    Task findMatchingTask(const genie::Task::ActionTypes &m_type, int targetUnit) noexcept;
    Size selectionSize() const noexcept;

    virtual void setCreationProgress(float progress) noexcept;
    void increaseCreationProgress(float progress) noexcept;
    float creationProgress() const noexcept;
    float hitpointsLeft() const noexcept;
    float healthLeft() const noexcept;
    void takeDamage(const genie::unit::AttackOrArmor &attack, const float damageMultiplier) noexcept;
    void kill() noexcept;
    bool isDying() const noexcept;
    bool isDead() const noexcept;

    void setMap(const MapPtr &newMap) noexcept override;
    void setPosition(const MapPos &pos, const bool initial = false) noexcept override;

    void setUnitData(const genie::Unit &data_) noexcept;
    const genie::Unit *data() const noexcept {return m_data; }

    int activeMissiles = 0;

    UnitManager &unitManager() const noexcept { return m_unitManager; }

    MapPos center() const noexcept {
        return position() + clearanceSize() / 2.;
    }

    float distanceTo(const MapPos &pos) const noexcept
    {
        const double centreDistance = position().distance(pos);
        const Size size = clearanceSize();
        const double clearance = util::hypot(size.width, size.height);//)//, std::max(otherSize.width, otherSize.height));
        return centreDistance - clearance;
    }

    Size clearanceSize() const noexcept {
        return Size(data()->Size.x * Constants::TILE_SIZE, data()->Size.y * Constants::TILE_SIZE);
    }

    double distanceTo(const Unit::Ptr &otherUnit) const noexcept
    {
        const double centreDistance = position().distance(otherUnit->position());
        const Size otherSize = otherUnit->clearanceSize();
        const Size size = clearanceSize();
        const double clearance = std::max(std::max(size.width, size.height), std::max(otherSize.width, otherSize.height));
        return centreDistance - clearance;
    }

protected:
    void forEachVisibleTile(std::function<void(const int, const int)> action);

    Unit(const genie::Unit &data_, const std::shared_ptr<Player> &player_, UnitManager &unitManager, const Type m_type);

    void removeAction(const ActionPtr &action);
    int taskGraphicId(const genie::Task::ActionTypes taskType, const IAction::UnitState state);
    void updateGraphic();

    const genie::Unit *m_data = nullptr;
    GraphicPtr movingGraphics;
    ActionPtr m_currentAction;
    std::deque<ActionPtr> m_actionQueue;

    std::unordered_set<Task> m_autoTargetTasks;

    float m_creationProgress = 0.f;

    UnitManager &m_unitManager;

    float m_damageTaken = 0.f;
    Time m_prevTime = 0;
};


