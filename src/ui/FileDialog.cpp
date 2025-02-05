#include "FileDialog.h"

#include "core/Utility.h"
#include "global/Config.h"
#include "render/SfmlRenderTarget.h"

#include <SFML/Graphics/RenderWindow.hpp>
#include <SFML/Graphics/RenderTarget.hpp>
#include <SFML/Graphics/Font.hpp>
#include <SFML/Graphics/Text.hpp>
#include <SFML/Window/Event.hpp>
#include <SFML/Graphics/RectangleShape.hpp>

FileDialog::FileDialog()
{
}

bool FileDialog::setup(int width, int height)
{
    m_renderWindow = std::make_unique<sf::RenderWindow>(sf::VideoMode(width, height), "freeaoe");
    m_renderWindow->setSize(sf::Vector2u(width, height));
    m_renderWindow->setView(sf::View(sf::FloatRect(0, 0, width, height)));



    {
        m_description = std::make_unique<sf::Text>("Please select the directory containing your Age of Empires 2 installation.", SfmlRenderTarget::defaultFont());
        m_description->setCharacterSize(20);
        const int descWidth = m_description->getLocalBounds().width;
        m_description->setPosition(width/2 - descWidth/2, 2);
        m_description->setFillColor(sf::Color::White);
    }

    const Size buttonSize(250, 50);

    m_fileList = std::make_unique<ListView>(SfmlRenderTarget::defaultFont(), ScreenRect(ScreenPos(width/2 - width*3/8, 55), Size(width*3/4, 550)));
    m_fileList->setCurrentPath(std::string());

    m_okButton = std::make_unique<Button>("OK", SfmlRenderTarget::defaultFont(), ScreenRect(ScreenPos(m_fileList->rect().x, 700), buttonSize));

    m_cancelButton = std::make_unique<Button>("Cancel", SfmlRenderTarget::defaultFont(), ScreenRect(ScreenPos(m_fileList->rect().right() - buttonSize.width, 700), buttonSize));
    m_cancelButton->enabled = true;

    m_openDownloadUrlButton = std::make_unique<Button>("Download trial version", SfmlRenderTarget::defaultFont(), ScreenRect(ScreenPos(m_fileList->rect().center().x - buttonSize.width/2, 700), buttonSize));
    m_openDownloadUrlButton->enabled = true;

#if defined(__linux__)
    m_winePath = Config::winePath();
    if (!m_winePath.empty()) {
        if (std::filesystem::exists(m_winePath + "/drive_c")) {
            m_winePath += "/drive_c";
        }
        m_goToWineButton = std::make_unique<Button>("Go to Wine folder", SfmlRenderTarget::defaultFont(), ScreenRect(ScreenPos(m_fileList->rect().x, m_fileList->rect().bottom() + 10), buttonSize));
        m_goToWineButton->enabled = true;
    }
#endif

    return true;
}

std::string FileDialog::getPath()
{
    std::string ret;

    while (m_renderWindow->isOpen()) {
        // Process events
        sf::Event event;
        if (!m_renderWindow->waitEvent(event)) {
            WARN << "failed to get event";
            break;
        }

        if (event.type == sf::Event::Closed) {
            m_renderWindow->close();
            continue;
        }

        if (m_openDownloadUrlButton->checkClick(event)) {
            util::openUrl("https://archive.org/details/AgeOfEmpiresIiTheConquerorsDemo", nullptr);
            continue;
        }

        if (m_cancelButton->checkClick(event)) {
            m_renderWindow->close();
        }

        if (m_okButton->checkClick(event)) {
            m_renderWindow->close();
            ret = m_fileList->currentText();
        }

#if defined(__linux__)
        if (m_goToWineButton) {
            if (m_goToWineButton->checkClick(event)) {
                m_fileList->setCurrentPath(std::filesystem::path(m_winePath));
            }
        }
#endif

        m_fileList->handleEvent(event);
        m_okButton->enabled = m_fileList->hasDataFolder;

        m_renderWindow->clear(sf::Color::Black);
        m_openDownloadUrlButton->render(m_renderWindow.get());
        m_cancelButton->render(m_renderWindow.get());
        m_okButton->render(m_renderWindow.get());
        m_fileList->render(m_renderWindow.get());
        m_renderWindow->draw(*m_description);
        if (m_errorText) {
            m_renderWindow->draw(*m_errorText);
        }

#if defined(__linux__)
        if (m_goToWineButton) {
            m_goToWineButton->render(m_renderWindow.get());
        }
#endif
        m_renderWindow->display();
    }

    return ret;
}

void FileDialog::setErrorString(const std::string &error) noexcept
{
    m_errorText = std::make_unique<sf::Text>("Failed to load game data: " + error, SfmlRenderTarget::defaultFont());
    m_errorText->setCharacterSize(17);
    const int textWidth = m_errorText->getLocalBounds().width;
    m_errorText->setPosition(m_renderWindow->getSize().x/2 - textWidth/2, 25);
    m_errorText->setFillColor(sf::Color(255, 128, 128));
}

Button::Button(const std::string &text, const sf::Font &font, const ScreenRect rect) :
    m_rect(rect)
{
    m_text = std::make_unique<sf::Text>(text, font);
    m_text->setCharacterSize(24);
    const int textWidth = m_text->getLocalBounds().width;
    const int textHeight = m_text->getLocalBounds().height;
    m_text->setPosition(m_rect.x + (m_rect.width/2 - textWidth/2), m_rect.y + (m_rect.height/2 - textHeight));

    m_background = std::make_unique<sf::RectangleShape>();

    m_background->setOutlineThickness(2);
    m_background->setPosition(m_rect.topLeft());
    m_background->setSize(m_rect.size());
}

bool Button::checkClick(const sf::Event &event)
{
    if (!enabled) {
        m_pressed = false;
        return false;
    }

    if (event.type == sf::Event::MouseMoved) {
        ScreenPos mousePos(event.mouseMove.x, event.mouseMove.y);

        if (!m_rect.contains(mousePos)) {
            m_pressed = false;
        }

        return false;
    }

    if (event.type != sf::Event::MouseButtonPressed && event.type != sf::Event::MouseButtonReleased) {
        return false;
    }

    ScreenPos mousePos(event.mouseButton.x, event.mouseButton.y);

    if (!m_rect.contains(mousePos)) {
        m_pressed = false;

        return false;
    }

    if (event.type == sf::Event::MouseButtonPressed) {
        m_pressed = true;
        return false;
    }

    return m_pressed;
}

void Button::render(sf::RenderWindow *window)
{
    if (!enabled) {
        m_background->setOutlineColor(sf::Color(128, 128, 128));
        m_background->setFillColor(sf::Color(64, 64, 64));
        m_text->setFillColor(sf::Color(128, 128, 128));
    } else if (m_pressed) {
        m_background->setOutlineColor(sf::Color::Black);
        m_background->setFillColor(sf::Color::White);
        m_text->setFillColor(sf::Color::Black);
    } else {
        m_background->setOutlineColor(sf::Color::White);
        m_background->setFillColor(sf::Color::Black);
        m_text->setFillColor(sf::Color::White);
    }
    window->draw(*m_background);
    window->draw(*m_text);
}

ListView::ListView(const sf::Font &font, const ScreenRect rect) :
    m_rect(rect)
{
    m_itemHeight = rect.height / numVisible;

    for (int i=0; i<numVisible; i++) {
        std::unique_ptr<sf::Text> text = std::make_unique<sf::Text>("-", font);
        text->setCharacterSize(18);
        text->setOutlineColor(sf::Color::Black);
        text->setOutlineThickness(1);
        const int textHeight = text->getLocalBounds().height;
        text->setPosition(rect.x + 10, rect.y + i * m_itemHeight + textHeight/3);

        m_texts.push_back(std::move(text));
    }

    m_background = std::make_unique<sf::RectangleShape>();

    m_background->setOutlineThickness(2);
    m_background->setPosition(m_rect.topLeft() - ScreenPos(2, 2));
    m_background->setSize(Size(m_rect.width + 4, m_rect.height + 4));
    m_background->setFillColor(sf::Color::Transparent);
    m_background->setOutlineColor(sf::Color::White);

    m_selectedOutline = std::make_unique<sf::RectangleShape>();
    m_selectedOutline->setOutlineThickness(1);
    m_selectedOutline->setPosition(m_rect.topLeft());
    m_selectedOutline->setSize(Size(m_rect.width - 20, m_itemHeight));
    m_selectedOutline->setFillColor(sf::Color::White);
    m_selectedOutline->setOutlineColor(sf::Color::Transparent);

    m_scrollBar = std::make_unique<sf::RectangleShape>();
    m_scrollBar->setOutlineThickness(2);
    m_scrollBar->setPosition(m_rect.topRight() + ScreenPos(-19, 5));
    m_scrollBar->setSize(Size(18, 10));
    m_scrollBar->setFillColor(sf::Color::White);
    m_scrollBar->setOutlineColor(sf::Color::Transparent);

    updateScrollbar();
}

void ListView::handleEvent(const sf::Event &event)
{
    if (event.type == sf::Event::MouseMoved) {
        ScreenPos mousePos(event.mouseMove.x, event.mouseMove.y);

        if (m_pressed) {
            moveScrollbar(mousePos.y);
        }

        return;
    }

    if (event.type == sf::Event::MouseButtonReleased) {
        m_pressed = false;
        return;
    }

    if (event.type == sf::Event::MouseWheelScrolled) {
        if (event.mouseWheelScroll.delta < 0) {
            setOffset(m_offset + 1);
        } else {
            setOffset(m_offset - 1);
        }
    }

    if (event.type != sf::Event::MouseButtonPressed) {
        return;
    }

    ScreenPos mousePos(event.mouseButton.x, event.mouseButton.y);
    if (!m_rect.contains(mousePos)) {
        return;
    }

    // scrollbar hit
    if (mousePos.x > m_rect.x + m_rect.width - 20) {
        moveScrollbar(mousePos.y);
        m_pressed = true;
        return;
    }

    int index = (event.mouseButton.y - m_rect.y) / m_itemHeight + m_offset;

    if (index >= m_list.size()) {
        return;
    }

    if (index != m_currentItem) {
        m_currentItem = index;
        return;
    }

    if (std::filesystem::is_directory(m_list[m_currentItem])) {
        setCurrentPath(std::filesystem::canonical(m_list[m_currentItem]).string());
    }
}

void ListView::render(sf::RenderWindow *window)
{
    window->draw(*m_background);

    if (m_currentItem - m_offset >= 0 && m_currentItem - m_offset < numVisible) {
        m_selectedOutline->setPosition(ScreenPos(m_rect.x, m_rect.y + (m_currentItem - m_offset) * m_itemHeight));
        window->draw(*m_selectedOutline);
    }

    for (std::unique_ptr<sf::Text> &text : m_texts) {
        window->draw(*text);
    }

    window->draw(*m_scrollBar);
}

void ListView::setCurrentPath(std::string path)
{
    m_list.clear();

    hasDataFolder = false;
    try {
        // avoid crashing
        if (!std::filesystem::exists(path) || !std::filesystem::is_directory(path)) {
            throw std::filesystem::filesystem_error("fuckings to boost which I blame for this shitty API", std::error_code());
        }
        std::filesystem::directory_iterator boostIsShit(path);
        for (std::filesystem::directory_entry entry : boostIsShit) {
            if (entry.path().filename() == "Data" && entry.is_directory()) {
                hasDataFolder = true;
            }

            m_list.push_back(entry.path().string());
        }

    } catch (const std::filesystem::filesystem_error &err) {
        WARN << "Err" << err.what();
        if (m_currentPath.empty()) {
            return;
        }

        path = m_currentPath.string();
    }

    if (!std::filesystem::path(path).parent_path().empty() && path != std::filesystem::path(path).parent_path()) {
        std::filesystem::path dotdot = path;
        dotdot += "/..";
        m_list.push_back(dotdot.string());
    }

    std::sort(m_list.begin(), m_list.end(), [](const std::filesystem::path &a, const std::filesystem::path &b){
        const bool aIsDir = std::filesystem::is_directory(a);
        const bool bIsDir = std::filesystem::is_directory(b);
        if (aIsDir != bIsDir) {
            return !aIsDir < !bIsDir;
        }

        const std::string aName = util::toLowercase(a.filename().string());
        const std::string bName = util::toLowercase(b.filename().string());
        const bool aDot = aName[0] == '.' && (aName.size() < 2 || aName[1] != '.');
        const bool bDot = bName[0] == '.' && (bName.size() < 2 || bName[1] != '.');
        if (aDot != bDot) {
            return aDot < bDot;
        }

        return a.filename() < b.filename();
    });

    m_currentItem = 0;
    m_offset = 0;

    for (size_t i=0; i<m_texts.size(); i++) {
        if (i < m_list.size()) {
            std::string filename = std::filesystem::path(m_list[i]).filename().string();
            if (filename.size() > 40) {
                filename.resize(40);
                filename += "...";
            }
            if (std::filesystem::is_directory(m_list[i])) {
                m_texts[i]->setString("[" + filename + "]");
            } else{
                m_texts[i]->setString(filename);
            }
        } else {
            m_texts[i]->setString("");
        }
    }

    updateScrollbar();

    m_currentPath = path;
}

void ListView::setOffset(int offset)
{
    if (offset > int(m_list.size()) - numVisible) {
        offset = int(m_list.size()) - numVisible;
    }

    if (offset < 0) {
        offset = 0;
    }

    if (offset == m_offset) {
        return;
    }

    m_offset = offset;

    for (size_t i=0; i<m_texts.size(); i++) {
        if (i+m_offset < m_list.size()) {
            std::string filename = std::filesystem::path(m_list[i+m_offset]).filename().string();
            if (filename.size() > 40) {
                filename.resize(40);
                filename += "...";
            }
            if (std::filesystem::is_directory(m_list[i+m_offset])) {
                m_texts[i]->setString("[" + filename + "]");
            } else{
                m_texts[i]->setString(filename);
            }
        } else {
            m_texts[i]->setString("");
        }
    }

    updateScrollbar();
}

std::string ListView::currentText() const
{
    return std::filesystem::canonical(m_currentPath).string();
}

void ListView::updateScrollbar() const
{
    if (m_list.empty()) {
        m_scrollBar->setSize(Size(0, 0));
        return;
    }

    float scrollbarSize =  m_rect.height * (float(numVisible) / m_list.size());
    scrollbarSize = std::min(scrollbarSize, m_rect.height);
    scrollbarSize = std::max(scrollbarSize, 10.f);
    m_scrollBar->setSize(Size(18, scrollbarSize));

    int scrollbarPos = m_rect.height * float(m_offset) / m_list.size();
    m_scrollBar->setPosition(m_rect.topRight() + ScreenPos(-18, scrollbarPos));
}

void ListView::moveScrollbar(int mouseY)
{
    float ratio = (mouseY - m_scrollBar->getSize().y/2 - m_rect.y) / m_rect.height;
    setOffset(m_list.size() * ratio);
}
