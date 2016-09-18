package levels {
	import characters.Cthullu;
	import characters.Player;

	import engine.Dialog;

	import engine.Inventory;
	import engine.Item;
	import engine.Level;
	import engine.Prop;
	import engine.visualnovel.EventChain;

	import items.Knife;

	import props.Boulder;

	public class TrainStation extends Level {

		[Embed(source="../../assets/backgrounds/subway.png")]
		public var BACKGROUND_SPRITE:Class;

		public var checkBoulderDialog:EventChain;

		public function TrainStation():void {
			super();

			checkBoulderDialog = createEventChain('checkedBoulder')
				.addDialog(Player, "It's just a rock...")
				.addDialog(Cthullu, "... maybe bash your head in it, really hard?")
				.addDialog(Player, "What is WRONG with you?")
				.addBreak()
				.addDialog(Player, "Seriously, man, I'm not doing anything.")
				.addDialog(Cthullu, "You buzzkill.")
		}

		public override function prepare():void {
			setBackground(BACKGROUND_SPRITE);
			//Game.playMusic("griefing_gunners");
		}

		public override function create():void {
			super.create();

			Prop.placeOnScene(this, new Boulder(), 155, 325);

			if(!Inventory.hasItemOfType("items::Knife")) {
				// TODO: helper method that only places item if not in inventory (track by unique item ID)
				Item.placeOnScene(this, new Knife(), 300, 300);
			}
		}

		public override function onPropInteract(prop:Prop):void {

			// TODO: fix messy API signature that requires instance instead of class

			if(prop is Boulder) {
				checkBoulderDialog.start();
			}
		}

		public override function onItemPick(item:Item):void {
			if(item is Knife) {
				createEventChain('pickedKnife')
					.addDialog(Player, "Oh look, a knife!")
					.addDialog(Cthullu, "Yep. Now kill yourself with it. Please?")
					.addDialog(Player, "Uuuhm, nope.")
					.addDialog(Cthullu, "Aww!")
					.start();
			}
		}
	}
}
