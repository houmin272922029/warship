/**
 * 日常视图基类
 * 
 * @author caiyaguang
 * 
 * @desc 快速加载ccbi方法
 * 
 */
var DailyBaseLayer = cc.Layer.extend({
	ctor : function(params){
		this._super(params);
	},
});

/**
* 扩展Layer类的方法，用于加载一个ccb文件
* @param ccbPath ccbi文件路径
* @param ccbOwner owner名字
* @param controller 用来绑定方法和变量的类
* @param parentsNode 父节点 (可省略)
* 
* @return 生成的ccb节点（同时会在绑定类中生成ccbNode变量，用来保存改节点）
*/
DailyBaseLayer.prototype.initCCBLayer = function(ccbPath, ccbOwner, controller, parentsNode){
	cc.BuilderReader.registerController(ccbOwner, {});
	controller.ccbNode = cc.BuilderReader.load(ccbPath, controller);

	if (parentsNode) {
		parentsNode.addChild(controller.ccbNode);
	}

	return controller.ccbNode;
}