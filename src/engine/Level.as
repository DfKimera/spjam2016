package engine {
	import engine.visualnovel.EventChain;

	public class Level extends Scene {

		public var eventChains:Object = {};

		public function createEventChain(id:String, onFinishCallback:Function = null):EventChain {
			if(eventChains[id]) {
				return eventChains[id];
			}

			var chain:EventChain = EventChain.create(this, onFinishCallback);
			eventChains[id] = chain;

			return chain;
		}

		public override function update():void {
			super.update();
			updateEventChains();
		}

		public function updateEventChains():void {
			for(var i:String in eventChains) {
				eventChains[i].update();
			}
		}

	}
}
