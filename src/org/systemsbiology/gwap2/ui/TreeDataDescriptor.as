package org.systemsbiology.gwap2.ui
{
	import com.adobe.serialization.json.JSON;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.controls.treeClasses.ITreeDataDescriptor;
	
	public class TreeDataDescriptor implements ITreeDataDescriptor
	{
		
		public var treeData:Object;
		
		public function TreeDataDescriptor()
		{
		}



		public function addChildAt(parent:Object, newChild:Object, index:int, model:Object = null):Boolean {
			trace("addChildAt");
			return true;
		}
		

		public function getChildren(node:Object, model:Object = null):ICollectionView {
			//trace("in getchildren");
			var arr:Array = treeData[node['parent_id']];
			for (var i:int = 0; i < arr.length; i++) {
				if (arr[i]['label'] == node['label']) {
					var ac:ArrayCollection = new ArrayCollection(arr[i]['children']);
					return ac;
				}
			}
			return null;
		}
		
		public function getData(node:Object, model:Object = null):Object {
			var s:String = JSON.encode(node);
			trace("getData gets object: " + s);
			return "Baz";
		}
		
		public function hasChildren(node:Object, model:Object = null):Boolean {
			//trace("hasChildren");
			//trace("parent_id = " + node['parent_id']);
			var o:Object = treeData[node['parent_id']];
			return (o != null);
		}
		
		public function isBranch(node:Object, model:Object = null):Boolean {
			//trace("isBranch");
			if (node.hasOwnProperty('experiment_id')) {
				return node['experiment_id'] == null;
			}
			return true;
		}
		
		public function removeChildAt(parent:Object, child:Object, index:int, model:Object = null):Boolean {
			//trace("removeChildAt");
			return true;
		}
		
		
		

	}
}