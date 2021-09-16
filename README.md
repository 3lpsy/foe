# A Search and Destroy Game

In foe, players start with a set number of pawns on the board. After the players have joined and confirmed their starting positions, they can make a single move each round. They can either move a certain number (3 by default) spaces or shoot at another player's pawn that is certain number spaces (3 by default) away.

At the moment, the project only consists of a backend, thought a frontend may be developed over time.

## Game States

### Unconfigured

The Game contract is initialized in this state. The gameCreator must call three configurable methods to set the rules for this game.

### WaitingForGameCreator

The game creator must join the game first. When joining a player submits their requested starting positions.

### Open

At this point, other users can join the game. If it is non public, then they must be on an allow list.

### WaitingForCoordReveal

After the configured interval, the game will be closed to new players. Once closed, players must validate their starting positions. Once each player has validated their positions via a commit/reveal, the game starts.

### AcceptingActions

The core game loop changes between three states: AcceptingActions, ConfirmingActions, AwaitingTick. During the AcceptingActions phase, players use a commit/reveal scheme to lock in their move.

### ConfirmingActions

Once each player has locked in their move, and after a certain interval, they need to validate their move.

### AwaitingTick

Once validated, the selected player can trigger the round via the `tick` method. The board will move and players will either perform their move or shoot actions and expend action points. Every three rounds, the players receive a new action point.

### Finished

Once the game has concluded, a winner is decided.
