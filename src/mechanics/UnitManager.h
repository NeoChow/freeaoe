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

#pragma once
#include <unordered_set>
#include "Unit.h"
#include "Missile.h"
#include "Building.h"

#include "Map.h"
class SfmlRenderTarget;

struct Camera;
typedef std::shared_ptr<Camera> CameraPtr;

struct Player;

struct MapPositionSorter
{
    bool operator()(const Unit::Ptr &lhs, const Unit::Ptr &rhs) const {
        const MapPos &mpos1 = lhs->position();
        const MapPos &mpos2 = rhs->position();
        if (mpos1.z != mpos2.z) {
            return mpos1.z > mpos2.z;
        }

        const ScreenPos pos1 = mpos1.toScreen();
        const ScreenPos pos2 = mpos2.toScreen();


        if (pos1.y != pos2.y) {
            return pos1.y < pos2.y;
        }

        if (pos1.x != pos2.x) {
            return pos1.x < pos2.x;
        }

        // std sucks
        return lhs < rhs;
    }
};

//class CameraPtr;
// IDEA: Class containing all entities, (adds, removes, updates them).
// Base class (EntitySpace?)
typedef std::vector<Unit::Ptr> UnitVector;
typedef std::unordered_set<Unit::Ptr> UnitSet;

class UnitManager
{
public:
    static constexpr int GaiaID = 0;

    enum class State {
        PlacingBuilding,
        SelectingAttackTarget,
        Default
    };

    UnitManager(const UnitManager&) = delete;
    const UnitManager &operator=(const UnitManager&) = delete;

    UnitManager();
    virtual ~UnitManager();

    void add(const Unit::Ptr &unit);
    void remove(const Unit::Ptr &unit);

    bool init();
    void setHumanPlayer(const std::shared_ptr<Player> &player) { m_humanPlayer = player; }

    bool update(Time time);
    void render(const std::shared_ptr<SfmlRenderTarget> &renderTarget, const std::vector<std::weak_ptr<Entity> > &visible);

    bool onLeftClick(const ScreenPos &screenPos, const CameraPtr &camera);
    void onRightClick(const ScreenPos &screenPos, const CameraPtr &camera);
    void onMouseMove(const MapPos &mapPos);

    void selectUnits(const ScreenRect &selectionRect, const CameraPtr &camera);
    void setMap(const MapPtr &map);
    const MapPtr &map() { return m_map; }

    void setSelectedUnits(const UnitSet &units);
    const UnitSet &selected() const { return m_selectedUnits; }

    const UnitVector &units() const { return m_units; }

    void placeBuilding(const int unitId, const std::shared_ptr<Player> &player);
    void enqueueProduceUnit(const genie::Unit *unitData, const UnitSet &producers);
    void enqueueResearch(const genie::Tech *techData, const UnitSet &producers);

    Unit::Ptr unitAt(const ScreenPos &pos, const CameraPtr &camera) const;
    Unit::Ptr clickedUnitAt(const ScreenPos &pos, const CameraPtr &camera);

    const std::unordered_set<Task> availableActions() const { return m_currentActions; }

    const Task defaultActionAt(const ScreenPos &pos, const CameraPtr &camera) const noexcept;
    void moveUnitTo(const Unit::Ptr &unit, const MapPos &targetPos);
    void selectAttackTarget();

    State state() const { return m_state; }

    void addMissile(const Missile::Ptr &missile) { m_missiles.insert(missile); }
    void addDecayingEntity(const DecayingEntity::Ptr &entity) { m_decayingEntities.insert(entity); }

    void onCombatantUnitsMoved() { m_unitsMoved = true; }

private:
    State m_state = State::Default;

    void playSound(const Unit::Ptr &unit);
    const Task taskForPosition(const Unit::Ptr &unit, const ScreenPos &pos, const CameraPtr &camera) const noexcept;

    std::unordered_set<Missile::Ptr> m_missiles;
    std::unordered_set<DecayingEntity::Ptr> m_decayingEntities;
    UnitVector m_units;
    UnitSet m_unitsWithActions;
    std::unordered_set<Task> m_currentActions;

    UnitSet m_selectedUnits;
    MapPtr m_map;
    sf::RenderTexture m_outlineOverlay;
    MoveTargetMarker::Ptr m_moveTargetMarker;

    Building::Ptr m_buildingToPlace;
    bool m_canPlaceBuilding;

    bool m_unitsMoved = true;

    MapPos m_previousCameraPos;
    std::weak_ptr<Player> m_humanPlayer;
};

