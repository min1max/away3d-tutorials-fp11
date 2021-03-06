package
{

	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.SkyBox;
	import away3d.primitives.SphereGeometry;
	import away3d.textures.BitmapCubeTexture;
	import away3d.textures.BitmapTexture;
	import away3d.utils.Cast;

	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.geom.Point;

	public class GlobeMaterialsTutorialListing02 extends GlobeMaterialsTutorialListingBase
	{
		// Diffuse map for the Earth's surface.
		[Embed(source="../embeds/earth_diffuse.jpg")]
		public static var EarthSurfaceDiffuse:Class;

		// Diffuse map for the Moon's surface.
		[Embed(source="../embeds/moon.jpg")]
		public static var MoonSurfaceDiffuse:Class;

		// Skybox textures.
		[Embed(source="../embeds/space_posX.jpg")]
		private var PosX:Class;
		[Embed(source="../embeds/space_negX.jpg")]
		private var NegX:Class;
		[Embed(source="../embeds/space_posY.jpg")]
		private var PosY:Class;
		[Embed(source="../embeds/space_negY.jpg")]
		private var NegY:Class;
		[Embed(source="../embeds/space_posZ.jpg")]
		private var PosZ:Class;
		[Embed(source="../embeds/space_negZ.jpg")]
		private var NegZ:Class;

		// Star texture.
		[Embed(source="../embeds/star.jpg")]
		private var StarTexture:Class;

		// Sun texture.
		[Embed(source="../embeds/sun.jpg")]
		private var SunTexture:Class;

		private var _earth:ObjectContainer3D;
		private var _moon:ObjectContainer3D;

		public function GlobeMaterialsTutorialListing02() {
			super();
		}

		override protected function onSetup():void {
			createSun();
			createEarth();
			createMoon();
			createDeepSpace();
			createStarField();
		}

		private function createSun():void {
			// Material.
			var bitmapData:BitmapData = blackToTransparent( Cast.bitmapData( SunTexture ) );
			var sunMaterial:TextureMaterial = new TextureMaterial( new BitmapTexture( bitmapData ) );
			sunMaterial.alphaBlending = true;
			// Geometry.
			var sun:Sprite3D = new Sprite3D( sunMaterial, 5000, 5000 );
			sun.x = 10000;
			_view.scene.addChild( sun );
		}

		private function createEarth():void {
			// Material.
			var earthMaterial:TextureMaterial = new TextureMaterial( Cast.bitmapTexture( EarthSurfaceDiffuse ) );
			// Container.
			_earth = new ObjectContainer3D();
			_earth.rotationY = rand( 0, 360 );
			_view.scene.addChild( _earth );
			// Surface geometry.
			var earthSurface:Mesh = new Mesh( new SphereGeometry( 100, 200, 100 ), earthMaterial );
			_earth.addChild( earthSurface );
		}

		private function createMoon():void {
			// Material.
			var moonMaterial:TextureMaterial = new TextureMaterial( Cast.bitmapTexture( MoonSurfaceDiffuse ) );
			// Container.
			_moon = new ObjectContainer3D();
			_moon.rotationY = rand( 0, 360 );
			_view.scene.addChild( _moon );
			// Surface geometry.
			var moonSurface:Mesh = new Mesh( new SphereGeometry( 50, 200, 100 ), moonMaterial );
			moonSurface.x = 1000;
			_moon.addChild( moonSurface );
		}

		private function createStarField():void {
			// Define material to be shared by all stars.
			var bitmapData:BitmapData = blackToTransparent( Cast.bitmapData( StarTexture ) );
			var starMaterial:TextureMaterial = new TextureMaterial( new BitmapTexture( bitmapData ) );
			starMaterial.alphaBlending = true;
			for( var i:uint = 0; i < 500; i++ ) {
				// Define unique star.
				var star:Sprite3D = new Sprite3D( starMaterial, 150, 150 );
				_view.scene.addChild( star );
				// Randomly position in spherical coordinates.
				var radius:Number = rand( 2000, 15000 );
				var elevation:Number = rand( -Math.PI, Math.PI );
				var azimuth:Number = rand( -Math.PI, Math.PI );
				// Spherical to cartesian.
				star.x = radius * Math.cos( elevation ) * Math.sin( azimuth );
				star.y = radius * Math.sin( elevation );
				star.z = radius * Math.cos( elevation ) * Math.cos( azimuth );
			}
		}

		private function createDeepSpace():void {
			// Cube texture.
			var cubeTexture:BitmapCubeTexture = new BitmapCubeTexture(
					Cast.bitmapData( PosX ), Cast.bitmapData( NegX ),
					Cast.bitmapData( PosY ), Cast.bitmapData( NegY ),
					Cast.bitmapData( PosZ ), Cast.bitmapData( NegZ ) );
			// Skybox geometry.
			var skyBox:SkyBox = new SkyBox( cubeTexture );
			_view.scene.addChild( skyBox );
		}

		override protected function onUpdate():void {
			super.onUpdate();
			_earth.rotationY += 0.05;
			_moon.rotationY -= 0.005;
		}

		private function rand( min:Number, max:Number ):Number {
		    return (max - min)*Math.random() + min;
		}

		private function blackToTransparent( original:BitmapData ):BitmapData {
			var bmd:BitmapData = new BitmapData( original.width, original.height, true, 0xFFFFFFFF );
			bmd.copyChannel( original, bmd.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA );
			return bmd;
		}
	}
}
