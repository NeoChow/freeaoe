#include "ActionFly.h"
#include "mechanics/Unit.h"
#include <genie/dat/Unit.h>
#include "mechanics/Map.h"

ActionFly::ActionFly(const std::shared_ptr<Unit> &unit, UnitManager *unitManager) :
    IAction(IAction::Type::Fly, unit, unitManager)
{

}


IAction::UpdateResult ActionFly::update(Time time)
{
    if (!m_lastUpdateTime) {
        m_lastUpdateTime = time;
        return UpdateResult::NotUpdated;
    }
    Unit::Ptr unit = m_unit.lock();
    if (!unit) {
        WARN << "Unit gone";
        return UpdateResult::Completed;
    }

    const float elapsed = time - m_lastUpdateTime;
    m_lastUpdateTime = time;

    const float movement = elapsed * unit->data()->Speed * 0.15;

    // Need to convert to screen, because I'm dumb and the angles are screen relative
    const ScreenPos screenMovement(cos(unit->angle()), sin(unit->angle()));
    MapPos pos = unit->position() + screenMovement.toMap() * movement;

    if (pos.x < 0) {
        pos.x = unit->map()->width() - 1;
    }
    if (pos.x >= unit->map()->width()) {
        pos.x = 0;
    }
    if (pos.y < 0) {
        pos.y = unit->map()->height() - 1;
    }
    if (pos.y >= unit->map()->height()) {
        pos.y = 0;
    }

    unit->setPosition(pos);

    return UpdateResult::Updated;
}

IAction::UnitState ActionFly::unitState() const
{
    return UnitState::Proceeding;
}
