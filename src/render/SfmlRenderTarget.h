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

#include "mechanics/Entity.h"
#include "IRenderTarget.h"

#include <resource/Graphic.h>
#include <SFML/Graphics/Texture.hpp>
#include <SFML/Graphics/Text.hpp>

namespace sf {
class RenderTarget;
class Font;
}

struct SfmlImage : public Drawable::Image
{
    SfmlImage() {}

    sf::Texture texture;
};

struct SfmlText : public Drawable::Text
{
    SfmlText() {}

    sf::Text text;
    ScreenPos lastPos;
    Alignment lastAlignment = AlignLeft;
};

class SfmlRenderTarget : public IRenderTarget
{

public:
    static const sf::Font &defaultFont();

    SfmlRenderTarget(const Size &size);
    SfmlRenderTarget(sf::RenderTarget &render_target);
    virtual ~SfmlRenderTarget();

    //----------------------------------------------------------------------------
    Size getSize() const override;
    void setSize(const Size size) const override;

    //----------------------------------------------------------------------------
    void draw(const sf::Image &image, ScreenPos pos) override;

    //----------------------------------------------------------------------------
    void draw(const sf::Texture &texture, ScreenPos pos) override;

    //----------------------------------------------------------------------------
    void draw(const sf::Drawable &shape) override;

    void draw(const ScreenRect &rect, const Drawable::Color &fillColor, const Drawable::Color &outlineColor = Drawable::Transparent, const float outlineSize = 1.) override;

    void draw(const Drawable::Rect &rect) override;
    void draw(const Drawable::Circle &circle) override;

    Drawable::Image::Ptr createImage(const Size &size, const uint8_t *bytes) override;
    void draw(const Drawable::Image::Ptr &image, const ScreenPos &position) override;
    void draw(const std::shared_ptr<IRenderTarget> &renderTarget) override;

    //----------------------------------------------------------------------------
    /// Displays frame.
    //
    void display() override;

    sf::RenderTarget *renderTarget_;

    std::shared_ptr<IRenderTarget> createTextureTarget(const Size &size) override;

    void clear() override;

    std::unique_ptr<sf::RenderTexture> m_renderTexture;


    Drawable::Text::Ptr createText() override;
    void draw(const Drawable::Text::Ptr &text) override;
};

