extends TextureButton


const TOOLTIP = preload("res://ui/TreeSelectorTooltip.tscn");

func _make_custom_tooltip(text:String):
  var rtl: RichTextLabel = TOOLTIP.instantiate();
  rtl.set_text(text);
  print(text);
  return rtl;
