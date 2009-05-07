package {
    import flare.data.DataSet;
    import flare.data.DataSource;
    import flare.scale.LinearScale;
    import flare.scale.ScaleType;
    import flare.vis.Visualization;
    import flare.vis.data.Data;
    import flare.vis.operator.encoder.ColorEncoder;
    import flare.vis.operator.encoder.ShapeEncoder;
    import flare.vis.operator.layout.AxisLayout;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.net.URLLoader;
 
    [SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="30")]
    public class Tutorial extends Sprite
    {
        private var vis:Visualization = new Visualization();
 
        public function Tutorial()
        {
            loadData();
        }
 
        private function loadData():void
        {
            var ds:DataSource = new DataSource(
                "http://nightingale.systemsbiology.net:3000/data.txt", "tab");
            var loader:URLLoader = ds.load();
            loader.addEventListener(Event.COMPLETE, function(evt:Event):void {
                var ds:DataSet = loader.data as DataSet;
                visualize(Data.fromDataSet(ds));
            });
        }
        
        public function getVis():Visualization {
        	return vis;
        }
 
        private function visualize(data:Data):void
        {
        	vis.data = data;
            //vis = new Visualization(data);
            vis.bounds = new Rectangle(0, 0, 600, 500);
            vis.x = 100;
            vis.y = 50;
            //////addChild(vis);
 			var layout:AxisLayout = new AxisLayout("data.date", "data.age");
            vis.operators.add(layout);
            var scale = new LinearScale();
            vis.operators.add(new ColorEncoder("data.cause", Data.NODES,
                "lineColor", ScaleType.CATEGORIES));
            vis.operators.add(new ShapeEncoder("data.race"));
            vis.data.nodes.setProperties({fillColor:0, lineWidth:2});
            vis.update();
        }
    }
}