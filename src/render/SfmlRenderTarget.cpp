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

#include "SfmlRenderTarget.h"
#include <SFML/Graphics/Texture.hpp>
#include <SFML/Graphics/Sprite.hpp>
#include "GraphicRender.h"
#include <SFML/Graphics/RenderTarget.hpp>
#include <SFML/Graphics/Font.hpp>
#include <SFML/Graphics/RectangleShape.hpp>
#include <SFML/Graphics/CircleShape.hpp>

#include "fonts/Alegreya-Bold.latin.h"
#include "mechanics/Map.h"

#define SCALE 1.

static inline sf::Color convertColor(const Drawable::Color &color)
{
    // so sue me, it's fun code
    // And the layout is even public in sf::Color

    return *reinterpret_cast<const sf::Color*>(&color);
}


const sf::Font &SfmlRenderTarget::defaultFont()
{
    // Ensure atomic creation
    static struct Font {
        Font() {
            font.loadFromMemory(resource_Alegreya_Bold_latin_data, resource_Alegreya_Bold_latin_size);
        }

        sf::Font font;
    } fontLoader;

    return fontLoader.font;
}

SfmlRenderTarget::SfmlRenderTarget(const Size &size)
{
//    m_renderTexture = std::make_unique<sf::RenderTexture>(size);
    m_renderTexture = std::make_unique<sf::RenderTexture>();
    m_renderTexture->create(size.width, size.height);
    renderTarget_ = m_renderTexture.get();
}

SfmlRenderTarget::SfmlRenderTarget(sf::RenderTarget &render_target)
{
    renderTarget_ = &render_target;
}

SfmlRenderTarget::~SfmlRenderTarget()
{
}

Size SfmlRenderTarget::getSize() const
{
    return sf::Vector2u(renderTarget_->getView().getSize().x / SCALE, renderTarget_->getView().getSize().y / SCALE);
}

void SfmlRenderTarget::setSize(const Size size) const
{
    renderTarget_->setView(sf::View(sf::FloatRect(0, 0, size.width, size.height)));
    m_camera->setViewportSize(size);
}

void SfmlRenderTarget::draw(const sf::Image &image, ScreenPos pos)
{
    sf::Texture texture;


    texture.loadFromImage(image);

    sf::Sprite sprite;
    sprite.setTexture(texture);
    sprite.setScale(SCALE, SCALE);

    sprite.setPosition(pos);

    renderTarget_->draw(sprite);
}

void SfmlRenderTarget::draw(const sf::Texture &texture, ScreenPos pos)
{
    sf::Sprite sprite;
    sprite.setTexture(texture);
    sprite.setScale(SCALE, SCALE);
    sprite.setPosition(pos);

    renderTarget_->draw(sprite);
}

void SfmlRenderTarget::draw(const sf::Drawable &shape)
{
    renderTarget_->draw(shape);
}

void SfmlRenderTarget::draw(const ScreenRect &rect, const Drawable::Color &fillColor, const Drawable::Color &outlineColor, const float outlineSize)
{
    sf::RectangleShape shape;

    shape.setOutlineColor(convertColor(outlineColor));
    shape.setOutlineThickness(outlineSize);
    shape.setFillColor(convertColor(fillColor));
    shape.setPosition(rect.topLeft());
    shape.setSize(sf::Vector2f(rect.width, rect.height));

    renderTarget_->draw(shape);
}

void SfmlRenderTarget::display()
{
    //  render_window_->Display();
}


Drawable::Image::Ptr SfmlRenderTarget::createImage(const Size &size, const uint8_t *bytes)
{
    std::shared_ptr<SfmlImage> ret = std::make_shared<SfmlImage>();
    sf::Image image;

    if (bytes) {
        image.create(size.width, size.height, bytes);
    } else if (size.isValid() ) {
        image.create(size.width, size.height, sf::Color::Transparent);
    } else {
        image.create(10, 10, sf::Color::Red);
    }

    ret->texture.loadFromImage(image);
    ret->size = size;

    // clang complains if we don't use move here because of mismatching return types and old compilers (I bet msvc)
    return std::move(ret);
}


void SfmlRenderTarget::draw(const Drawable::Rect &rect)
{
    sf::RectangleShape shape;

    if (rect.borderSize > 0) {
        shape.setOutlineColor(convertColor(rect.borderColor));
        shape.setOutlineThickness(rect.borderSize);
    }

    if (rect.filled) {
        shape.setFillColor(convertColor(rect.fillColor));
    }

    shape.setPosition(rect.rect.topLeft());
    shape.setSize(rect.rect.size());

    renderTarget_->draw(shape);
}

void SfmlRenderTarget::draw(const Drawable::Circle &circle)
{
    sf::CircleShape shape;

    if (circle.borderSize > 0) {
        shape.setOutlineColor(convertColor(circle.borderColor));
        shape.setOutlineThickness(circle.borderSize);
    }

    if (circle.filled) {
        shape.setFillColor(convertColor(circle.fillColor));
    }

    if (circle.pointCount > 0) {
        shape.setPointCount(circle.pointCount);
    }

    if (circle.aspectRatio != 1.) {
        shape.setScale(1., circle.aspectRatio);
    }

    shape.setPosition(circle.center);
    shape.setRadius(circle.radius);

    renderTarget_->draw(shape);
}

void SfmlRenderTarget::draw(const Drawable::Image::Ptr &image, const ScreenPos &position)
{
    if (!image) {
        WARN << "can't render null image";
        return;
    }

    const std::shared_ptr<const SfmlImage> sfmlImage = std::static_pointer_cast<const SfmlImage>(image);

    sf::Sprite sprite;
    sprite.setTexture(sfmlImage->texture);
    sprite.setScale(SCALE, SCALE);
    sprite.setPosition(position);

    renderTarget_->draw(sprite);
}


std::shared_ptr<IRenderTarget> SfmlRenderTarget::createTextureTarget(const Size &size)
{
    return std::make_shared<SfmlRenderTarget>(size);
}


void SfmlRenderTarget::clear()
{
    renderTarget_->clear();
}


void SfmlRenderTarget::draw(const std::shared_ptr<IRenderTarget> &renderTarget)
{
    if (!renderTarget) {
        WARN << "can't render null render target";
        return;
    }

    const std::shared_ptr<const SfmlRenderTarget> sfmlRenderTarget = std::static_pointer_cast<const SfmlRenderTarget>(renderTarget);

    if (!sfmlRenderTarget->m_renderTexture) {
        return;
    }

    sfmlRenderTarget->m_renderTexture->display();
    draw(sfmlRenderTarget->m_renderTexture->getTexture(), ScreenPos(0, 0));
}


Drawable::Text::Ptr SfmlRenderTarget::createText()
{
    std::shared_ptr<SfmlText> ret = std::make_shared<SfmlText>();
    ret->text.setFont(defaultFont());
    return std::move(ret);
}

void SfmlRenderTarget::draw(const Drawable::Text::Ptr &text)
{
    if (!text) {
        WARN << "can't render null text";
        return;
    }

    const std::shared_ptr<SfmlText> sfmlText = std::static_pointer_cast<SfmlText>(text);

    bool changed = false;

    if (sfmlText->text.getCharacterSize() != text->pointSize) {
        sfmlText->text.setCharacterSize(text->pointSize);
        changed = true;
    }

    if (sfmlText->text.getString() != text->string) {
        sfmlText->text.setString(text->string);
        changed = true;
    }

    sfmlText->text.setFillColor(convertColor(text->color));
    if (text->outlineColor.a > 0) {
        sfmlText->text.setOutlineColor(convertColor(text->outlineColor));
        sfmlText->text.setOutlineThickness(2);

    }

    if (sfmlText->lastAlignment != text->alignment || sfmlText->lastPos != text->position || changed) {
        sfmlText->lastPos = text->position;
        sfmlText->lastAlignment = text->alignment;

        if (text->alignment == Drawable::Text::AlignRight) {
            sfmlText->text.setPosition(sf::Vector2f(text->position.x - sfmlText->text.getLocalBounds().width, text->position.y));
        } else {
            sfmlText->text.setPosition(text->position);
        }
    }
    renderTarget_->draw(sfmlText->text);
}
