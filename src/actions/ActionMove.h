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

#include "core/Constants.h"
#include "actions/IAction.h"
#include "mechanics/Unit.h"
#include "mechanics/Map.h"

#include <genie/dat/TerrainRestriction.h>

#include <bitset>

class ActionMove : public IAction
{

public:
#ifdef DEBUG
    static std::vector<MapPos> testedPoints;
#endif
    virtual ~ActionMove();

    UpdateResult update(Time time) noexcept override;

    static std::shared_ptr<ActionMove> moveUnitTo(const Unit::Ptr &unit, MapPos destination, const Task &task) noexcept;
    static std::shared_ptr<ActionMove> moveUnitTo(const Unit::Ptr &unit, MapPos destination) noexcept;
    const std::vector<MapPos> &path() const noexcept { return m_path; }
    genie::Task::ActionTypes taskType() const noexcept override { return genie::Task::MoveTo; }

private:
    ActionMove(MapPos destination, const Unit::Ptr &unit, const Task &task);

    MapPos findClosestWalkableBorder(const MapPos &start, const MapPos &target, int coarseness) noexcept;

    std::vector<MapPos> findPath(MapPos start, MapPos end, int coarseness) noexcept;
    bool isPassable(const float x, const float y) noexcept;

    void updatePath() noexcept;

    MapPtr m_map;
    MapPos m_destination;
    std::vector<MapPos> m_path;
    std::vector<float> m_terrainMoveMultipliers;
    float m_speed;

    bool m_targetReached;
    std::bitset<Constants::TILE_SIZE * Constants::TILE_SIZE * Constants::MAP_MAX_SIZE * Constants::MAP_MAX_SIZE> m_passable;
    std::bitset<Constants::TILE_SIZE * Constants::TILE_SIZE * Constants::MAP_MAX_SIZE * Constants::MAP_MAX_SIZE> m_passableCached;
    bool m_passableDirty = false;
};

