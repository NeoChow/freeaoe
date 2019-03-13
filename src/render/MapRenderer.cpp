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

#include "MapRenderer.h"
#include "IRenderTarget.h"
#include "core/Constants.h"
#include <resource/AssetManager.h>
#include <resource/DataManager.h>

MapRenderer::MapRenderer() :
    m_camChanged(true),
    m_xOffset(0),
    m_yOffset(0),
    m_rRowBegin(0),
    m_rRowEnd(0),
    m_rColBegin(0),
    m_rColEnd(0),
    m_elevationHeight(DataManager::Inst().terrainBlock().ElevHeight)
{
}

MapRenderer::~MapRenderer()
{
}

bool MapRenderer::update(Time /*time*/)
{
    if (!m_map) {
        return false;
    }

    const MapPos cameraPos = renderTarget_->camera()->targetPosition();

    if (!m_camChanged && m_lastCameraPos == cameraPos &&
        (m_textureTarget && m_textureTarget->getSize() == renderTarget_->getSize()) &&
        !m_map->tilesUpdated()) {
        return false;
    }

    // Get the absolute map positions of the rendertarget corners
    const ScreenPos camCenter(renderTarget_->getSize().width / 2.0, renderTarget_->getSize().height / 2.0);

    // relative map positions (from center) //only changes if renderTargets resolution does
    const MapPos center = camCenter.toMap();
    const MapPos bottomLeft = ScreenPos(0, renderTarget_->getSize().height).toMap();
    const MapPos topRight = ScreenPos(renderTarget_->getSize().width, 0).toMap();
    const MapPos bottomRight = ScreenPos(renderTarget_->getSize().width, renderTarget_->getSize().height).toMap();

    // absolute map positions
    MapPos topLeftMp = cameraPos - center;
    MapPos botRightMp = cameraPos + (bottomRight - center);

    MapPos topRightMp = cameraPos + (topRight - center);
    MapPos botLeftMp = cameraPos + (bottomLeft - center);

    // get column and row boundaries for rendering
    m_rColBegin = botLeftMp.x / Constants::TILE_SIZE;
    if (m_rColBegin > m_map->getCols()) {
        WARN << "E: Somethings fishy... (rColBegin_ > map_->getCols())";
    }
    m_rColBegin = std::clamp(m_rColBegin, 0, m_map->getCols());

    m_rColEnd = topRightMp.x / Constants::TILE_SIZE;
    m_rColEnd++; //round up
    if (m_rColEnd < 0) {
        WARN << "E: Somethings fishy... (rColEnd_ < 0)";
    }
    m_rColEnd = std::clamp(m_rColEnd, 0, m_map->getCols());

    m_rRowBegin = topLeftMp.y / Constants::TILE_SIZE;
    if (m_rRowBegin > m_map->getRows()) {
        WARN << "E: Somethings fishy... (rRowBegin > map_->getRows())";
    }
    m_rRowBegin = std::clamp(m_rRowBegin, 0, m_map->getRows());

    m_rRowEnd = botRightMp.y / Constants::TILE_SIZE;
    m_rRowEnd++; // round up
    if (m_rRowEnd < 0) {
        WARN << "E: Somethings fishy... (rColEnd_ < 0)";
    }
    m_rRowEnd = std::clamp(m_rRowEnd, 0, m_map->getRows());

    // Calculating screen offset to MapPos(rColBegin, rColEnd):
    const MapPos offsetMp(m_rColBegin * Constants::TILE_SIZE, m_rRowBegin * Constants::TILE_SIZE);
    ScreenPos offsetSp = (offsetMp - topLeftMp).toScreen();

    m_xOffset = offsetSp.x;
    m_yOffset = offsetSp.y;

    m_lastCameraPos = cameraPos;
    m_camChanged = false;

    updateTexture();

    m_map->flushDirty();;

    return true;
}

void MapRenderer::display()
{
    if (!m_textureTarget || m_textureTarget->getSize() != renderTarget_->getSize()) {
        updateTexture();
    }

    renderTarget_->draw(m_textureTarget);
}

void MapRenderer::setMap(const MapPtr &map)
{
    m_map = map;

    m_rRowBegin = m_rColBegin = 0;
    m_rRowEnd = m_map->getRows();
    m_rColEnd = m_map->getCols();

    m_camChanged = true;
}

void MapRenderer::updateTexture()
{
    if (!m_textureTarget || m_textureTarget->getSize() == renderTarget_->getSize()) {
        m_textureTarget = renderTarget_->createTextureTarget(renderTarget_->getSize());
    }

    m_textureTarget->clear();

    Drawable::Circle invalidIndicator;
    invalidIndicator.radius = Constants::TILE_SIZE;
    invalidIndicator.pointCount = 4;
    invalidIndicator.aspectRatio = 0.5;
    invalidIndicator.filled = true;
    invalidIndicator.fillColor = Drawable::Red;
//    sf::CircleShape invalidIndicator(Constants::TILE_SIZE, 4);
//    invalidIndicator.setScale(1, 0.5);
//    invalidIndicator.setFillColor(sf::Color::Red);
//    invalidIndicator.setOutlineThickness(3);
//    invalidIndicator.setOutlineColor(sf::Color::Transparent);

//    sf::Text text;
//    text.setFont(SfmlRenderTarget::defaultFont());
//    text.setOutlineColor(sf::Color::Transparent);
//    text.setFillColor(sf::Color::White);
//    text.setCharacterSize(12);

    for (int col = m_rColBegin; col < m_rColEnd; col++) {
        for (int row = m_rRowEnd-1; row >= m_rRowBegin; row--) {
            MapTile &mapTile = m_map->getTileAt(col, row);

            MapRect rect;
            rect.x = col * Constants::TILE_SIZE;
            rect.y = row * Constants::TILE_SIZE;
            rect.z = mapTile.elevation * m_elevationHeight;
            rect.width = Constants::TILE_SIZE;
            rect.height = Constants::TILE_SIZE;

            // col and row are in map coordinates, so the top corners when rotated 45° we don't need to draw
//            if (!renderTarget_->camera()->isVisible(rect)) {
//                continue;
//            }

            ScreenPos spos = renderTarget_->camera()->absoluteScreenPos(rect.topLeft());

            // If we wanted to do this 100% correctly, we would need to use the hotspot from the
            // filtered SLP and then always offset with yOffset, but this is good enough for now.
            spos.y -= Constants::TILE_SIZE_VERTICAL / 2;
            if (mapTile.yOffset > 0) {
                spos.y -= mapTile.yOffset * 2;
            }

            TerrainPtr terrain = AssetManager::Inst()->getTerrain(mapTile.terrainId);

            if (!terrain) {
                invalidIndicator.center = spos + ScreenPos(Constants::TILE_SIZE_HORIZONTAL/2, Constants::TILE_SIZE_VERTICAL/2);
                m_textureTarget->draw(invalidIndicator);
                continue;
            }

            m_textureTarget->draw(terrain->texture(mapTile, renderTarget_), spos);
//            text.setString(std::to_string(col) + "," + std::to_string(row));
//            text.setPosition(spos.x, spos.y);
//            m_textureTarget.draw(text);
        }
    }
}
