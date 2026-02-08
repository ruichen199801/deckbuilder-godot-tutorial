# Card UI state machine
#       | aiming started notification
#   EventBus
#       | subscribed nodes receive signal
#  CardTargetSelector + Other node who cares
#
# Without this, state machine needs to emit singal to
# CardUI->Hand->BattleUI->...->CardTargetSelector,
# causing coupling and communication overhead.
#
# Need to register this class as an AutoLoad in Project Settings.
extends Node

# Card-related events
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
