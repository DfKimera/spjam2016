package engine {

	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxExtendedSprite;

	public class Prop extends FlxExtendedSprite {

		public function Prop():void {
			this.mouseReleasedCallback = this._onInteract;
		}

		protected function _onInteract(spr:FlxExtendedSprite, x:int, y:int):void {
			trace("Prop interaction: ", this, spr, x, y);

			if(FlxG.state is Scene) {
				var scene:Scene = (FlxG.state as Scene);

				if(Inventory.isHoldingItem()) {
					this._onItemUse( Inventory.getHeldItem() );
					Inventory.releaseItemOnCursor();
					return;
				}
			}

			SFX.play("click");

			this.onInteract();

			if(FlxG.state is Scene) {
				(FlxG.state as Scene).onPropInteract(this);
			}

		}

		protected function _onItemUse(item:Item):void {

			trace("Used item on prop", this, item);

			SFX.play("use");

			item._onUse();
			this.onItemUse(item);

			if(FlxG.state is Scene) {
				(FlxG.state as Scene).onItemUse(this, item);
			}

		}

		public override function update():void {
			super.update();

			if(this.mouseOver) {
				this.updateCursor();
			}
		}

		public function updateCursor():void {
			if(Inventory.isHoldingItem()) {
				Cursor.useHand();
			} else {
				Cursor.useEye();
			}
		}

		/**
		 * Removes the prop from the scene
		 */
		public function remove():void {

			var prop:Prop = this;

			Utils.fadeOut(this, Config.PROP_FADE_DELAY, function ():void {
				if(FlxG.state is Scene) {
					(FlxG.state as Scene).props.remove(prop);
				}
				prop.kill();
				prop.destroy();
			});
		}

		/**
		 * @abstract
		 * Called when the player interacts with this prop.
		 */
		public function onInteract():void {

		}

		/**
		 * @abstract
		 * Called when an item is used on this prop.
		 * @param item Iten The used item.
		 */
		public function onItemUse(item:Item):void {

		}

		// -------------------------------------------------------------------------------------------------------------

		/**
		 * Places a prop on the scene
		 * @param scene Scene The scene to place on.
		 * @param prop Prop The prop instance to place.
		 * @param x int The prop position on the scene.
		 * @param y int
		 */
		public static function placeOnScene(scene:Scene, prop:Prop, x:int, y:int):Prop {
			prop.x = x;
			prop.y = y;
			scene.props.add(prop);

			trace("Prop placed: ", prop, x, y, prop.ID);
			return prop;
		}

	}
}
