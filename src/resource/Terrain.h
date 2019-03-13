/*
    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) 2012  <copyright holder> <email>

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

#include "render/IRenderTarget.h"
#include "Resource.h"
#include "mechanics/MapTile.h"
#include "core/Logger.h"

#include <genie/dat/Terrain.h>

#include <genie/resource/SlpFile.h>

#include <unordered_map>

class SlpFile;

class Terrain;
typedef std::shared_ptr<Terrain> TerrainPtr;

class Terrain
{
public:
    const int32_t id;
    //----------------------------------------------------------------------------
    /// @param Id resource id
    //
    Terrain(unsigned int id_);
    virtual ~Terrain();

    bool load();

    const genie::Terrain &data();

    static uint8_t blendMode(const uint8_t ownMode, const uint8_t neighborMode);

    uint32_t coordinatesToFrame(int x, int y);

    const Drawable::Image::Ptr &texture(const MapTile &tile, const IRenderTargetPtr &renderer);

private:
    void addOutline(const Size &size, uint8_t *pixels);

    genie::Terrain m_data;
    genie::SlpFilePtr m_slp;

    std::unordered_map<MapTile, Drawable::Image::Ptr> m_textures;

    bool m_isLoaded = false;
};

