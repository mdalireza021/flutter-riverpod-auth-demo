class AvailableOption {
  AvailableOption({
    this.disabled,
    this.group,
    this.selected,
    this.text,
    this.value,
  });

  bool? disabled;
  dynamic group;
  bool? selected;
  String? text;
  String? value;

  AvailableOption copyWith({
    bool? disabled,
    dynamic group,
    bool? selected,
    String? text,
    String? value,
  }) =>
      AvailableOption(
        disabled: disabled ?? this.disabled,
        group: group ?? this.group,
        selected: selected ?? this.selected,
        text: text ?? this.text,
        value: value ?? this.value,
      );

  factory AvailableOption.fromJson(Map<String, dynamic> json) => AvailableOption(
    disabled: json["Disabled"],
    group: json["Group"],
    selected: json["Selected"],
    text: json["Text"],
    value: json["Value"],
  );

  Map<String, dynamic> toJson() => {
    "Disabled": disabled,
    "Group": group,
    "Selected": selected,
    "Text": text,
    "Value": value,
  };
}