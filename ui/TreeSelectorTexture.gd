extends TextureButton


const TOOLTIP = preload("res://ui/TreeSelectorTooltip.tscn");
var tooltip: Control = null;

func _process(delta):
  if tooltip:
    tooltip.get_parent().position.y -= 300;
    tooltip = null;

func _make_custom_tooltip(text:String):
  var rtl: RichTextLabel = TOOLTIP.instantiate();
  rtl.set_text(text);
  tooltip = rtl;
  return rtl;
