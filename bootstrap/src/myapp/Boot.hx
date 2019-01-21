package myapp;

class Boot {

	static public function main() : Void {
		trace("booting...");
		boot();
	}

	static function boot() : Void {
		trace("booted!");
		new App();
	}
}
