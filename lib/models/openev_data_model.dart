// To parse required this JSON data, do

import 'dart:convert';

List<Openev> openevFromJson(String str) => List<Openev>.from(json.decode(str).map((x) => Openev.fromJson(x)));

String openevToJson(List<Openev> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Openev {
    Openev({
        this.uid,
        this.name,
        this.vendorName,
        this.address,
        this.latitude,
        this.longitude,
        this.city,
        this.country,
        this.open,
        this.close,
        this.staff,
        this.paymentModes,
        this.contactNumbers,
        this.stationType,
        this.postalCode,
        this.zone,
        this.available,
        this.capacity,
        this.costPerUnit,
        this.powerType,
        this.total,
        this.type,
        this.vehicleType,
        this.logoUrl,
    });

    final String? uid;
    final String? name;
    final VendorName? vendorName;
    final String? address;
    final double? latitude;
    final double? longitude;
    final City? city;
    final Country? country;
    final String? open;
    final String? close;
    final Staff? staff;
    final PaymentModes? paymentModes;
    final String? contactNumbers;
    final StationType? stationType;
    final String? postalCode;
    final Zone? zone;
    final dynamic available;
    final Capacity? capacity;
    final AvailableEnum? costPerUnit;
    final PowerType? powerType;
    final dynamic total;
    final Type? type;
    final VehicleType? vehicleType;
    final String? logoUrl;

    factory Openev.fromJson(Map<String, dynamic> json) => Openev(
        uid: json["uid"] == null ? null : json["uid"],
        name: json["name"] == null ? null : json["name"],
        vendorName: vendorNameValues.map[json["vendor_name"]]!,
        address: json["address"] == null ? null : json["address"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        city: cityValues.map[json["city"]]!,
        country: countryValues.map[json["country"]]!,
        open: json["open"] == null ? null : json["open"],
        close: json["close"] == null ? null : json["close"],
        staff: staffValues.map[json["staff"]]!,
        paymentModes: paymentModesValues.map[json["payment_modes"]]!,
        contactNumbers: json["contact_numbers"] == null ? null : json["contact_numbers"],
        stationType: stationTypeValues.map[json["station_type"]]!,
        postalCode: json["postal_code"] == null ? null : json["postal_code"],
        zone: zoneValues.map[json["zone"]]!,
        available: json["available"],
        capacity: capacityValues.map[json["capacity"]]!,
        costPerUnit: availableEnumValues.map[json["cost_per_unit"]]!,
        powerType: powerTypeValues.map[json["power_type"]]!,
        total: json["total"],
        type: typeValues.map[json["type"]]!,
        vehicleType: vehicleTypeValues.map[json["vehicle_type"]]!,
        logoUrl: json["logo_url"] == null ? null : json["logo_url"],
    );

    Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "vendor_name": vendorNameValues.reverse[vendorName],
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "city": cityValues.reverse[city],
        "country": countryValues.reverse[country],
        "open": open,
        "close": close,
        "staff": staffValues.reverse[staff],
        "payment_modes": paymentModesValues.reverse[paymentModes],
        "contact_numbers": contactNumbers,
        "station_type": stationTypeValues.reverse[stationType],
        "postal_code": postalCode,
        "zone": zoneValues.reverse[zone],
        "available": available,
        "capacity": capacityValues.reverse[capacity],
        "cost_per_unit": availableEnumValues.reverse[costPerUnit],
        "power_type": powerTypeValues.reverse[powerType],
        "total": total,
        "type": typeValues.reverse[type],
        "vehicle_type": vehicleTypeValues.reverse[vehicleType],
        "logo_url": logoUrl,
    };
}

enum AvailableEnum { NA, THE_0_PER_UNIT, THE_5_PER_UNIT, THE_15_PER_UNIT, THE_25_PER_UNIT, THE_11_PER_UNIT, THE_2_PER_UNIT, THE_20_PER_UNIT, THE_19_PER_UNIT, THE_285_PER_UNIT, THE_18_PER_UNIT, THE_21_PER_UNIT, THE_273_PER_UNIT, THE_205_PER_UNIT, THE_13_PER_UNIT }

final availableEnumValues = EnumValues({
    "NA": AvailableEnum.NA,
    "₹0 per unit": AvailableEnum.THE_0_PER_UNIT,
    "₹11 per unit": AvailableEnum.THE_11_PER_UNIT,
    "₹13 per unit": AvailableEnum.THE_13_PER_UNIT,
    "₹15 per unit": AvailableEnum.THE_15_PER_UNIT,
    "₹18 per unit": AvailableEnum.THE_18_PER_UNIT,
    "₹19 per unit": AvailableEnum.THE_19_PER_UNIT,
    "₹2.05 per unit": AvailableEnum.THE_205_PER_UNIT,
    "₹20 per unit": AvailableEnum.THE_20_PER_UNIT,
    "₹21 per unit": AvailableEnum.THE_21_PER_UNIT,
    "₹25 per unit": AvailableEnum.THE_25_PER_UNIT,
    "₹2.73 per unit": AvailableEnum.THE_273_PER_UNIT,
    "₹2.85 per unit": AvailableEnum.THE_285_PER_UNIT,
    "₹2 per unit": AvailableEnum.THE_2_PER_UNIT,
    "₹5 per unit": AvailableEnum.THE_5_PER_UNIT
});

enum Capacity { THE_15_K_W, THE_33_K_W, THE_30_K_W, THE_20_K_W, THE_22_K_W, THE_142_K_W, THE_50_K_W, THE_7_K_W, THE_74_K_W, THE_33_K_WH, THE_10_K_WH, THE_60_K_WH, THE_16_K_W, THE_56_K_W, THE_10_K_W, THE_28_K_W }

final capacityValues = EnumValues({
    "10 kW": Capacity.THE_10_K_W,
    "10 kWh": Capacity.THE_10_K_WH,
    "142 kW": Capacity.THE_142_K_W,
    "15 kW": Capacity.THE_15_K_W,
    "16 kW": Capacity.THE_16_K_W,
    "20 kW": Capacity.THE_20_K_W,
    "22 kW": Capacity.THE_22_K_W,
    "28 kW": Capacity.THE_28_K_W,
    "30 kW": Capacity.THE_30_K_W,
    "3.3 kW": Capacity.THE_33_K_W,
    "3.3 kWh": Capacity.THE_33_K_WH,
    "50 kW": Capacity.THE_50_K_W,
    "56 kW": Capacity.THE_56_K_W,
    "60 kWh": Capacity.THE_60_K_WH,
    "7.4 kW": Capacity.THE_74_K_W,
    "7 kW": Capacity.THE_7_K_W
});

enum City { DELHI, NEW_DELHI, DWARKA }

final cityValues = EnumValues({
    "Delhi": City.DELHI,
    "Dwarka": City.DWARKA,
    "New Delhi": City.NEW_DELHI
});

enum Country { INDIA, COUNTRY_INDIA }

final countryValues = EnumValues({
    "India ": Country.COUNTRY_INDIA,
    "India": Country.INDIA
});

enum PaymentModes { CARD_E_WALLET_UPI, E_WALLET, CASH_E_WALLET, PAYMENT_MODES_E_WALLET, ONLINE_THROUGH_APP_E_WALLETS, UPI, E_WALLET_CASH_CREDIT_DEBIT_CARD, E_WALLET_UPI, E_WALLET_CASH, JIO_BP_PULSE_APP_WALLET, CASH_UPI }

final paymentModesValues = EnumValues({
    "Card, E-Wallet, UPI": PaymentModes.CARD_E_WALLET_UPI,
    "Cash/E-Wallet": PaymentModes.CASH_E_WALLET,
    "Cash/UPI": PaymentModes.CASH_UPI,
    "E-Wallet": PaymentModes.E_WALLET,
    "E-wallet, cash": PaymentModes.E_WALLET_CASH,
    "E-wallet,cash,Credit,Debit Card": PaymentModes.E_WALLET_CASH_CREDIT_DEBIT_CARD,
    "E-wallet, UPI": PaymentModes.E_WALLET_UPI,
    "Jio-bp Pulse app wallet": PaymentModes.JIO_BP_PULSE_APP_WALLET,
    "Online through App (e-wallets)": PaymentModes.ONLINE_THROUGH_APP_E_WALLETS,
    "E-wallet": PaymentModes.PAYMENT_MODES_E_WALLET,
    "UPI": PaymentModes.UPI
});

enum PowerType { DC, AC }

final powerTypeValues = EnumValues({
    "AC": PowerType.AC,
    "DC": PowerType.DC
});

enum Staff { UNSTAFFED, STAFFED, STAFF_STAFFED }

final staffValues = EnumValues({
    "Staffed": Staff.STAFFED,
    "staffed": Staff.STAFF_STAFFED,
    "Unstaffed": Staff.UNSTAFFED
});

enum StationType { CHARGING, BATTERY_SWAPPING }

final stationTypeValues = EnumValues({
    "battery_swapping": StationType.BATTERY_SWAPPING,
    "charging": StationType.CHARGING
});

enum Type { BEVC_DC_001, BEVC_AC_001, AC_TYPE_2, CCS2_CHADEMO_TYPE_2_AC, CCS_CH_ADE_MO, THE_5_A_15_A_SOCKET, TYPE_2_PLUG, TYPE_2, AC001, T2, DC, DC_001, EVRE_AC001, EVRE_DC001, IEC_60309, GBT, CCS, BATTERY_SWAPPING, TYPE_2_AC, DC001 }

final typeValues = EnumValues({
    "AC001": Type.AC001,
    "AC Type 2": Type.AC_TYPE_2,
    "battery_swapping": Type.BATTERY_SWAPPING,
    "BEVC AC 001": Type.BEVC_AC_001,
    "BEVC DC 001": Type.BEVC_DC_001,
    "CCS": Type.CCS,
    "CCS2/CHADEMO/TYPE 2 AC": Type.CCS2_CHADEMO_TYPE_2_AC,
    "CCS/ CHAdeMO": Type.CCS_CH_ADE_MO,
    "DC": Type.DC,
    "DC001": Type.DC001,
    "DC-001": Type.DC_001,
    "EVRE AC001": Type.EVRE_AC001,
    "EVRE DC001": Type.EVRE_DC001,
    "GBT": Type.GBT,
    "IEC_60309": Type.IEC_60309,
    "T2": Type.T2,
    "5A/15A Socket": Type.THE_5_A_15_A_SOCKET,
    "TYPE - 2": Type.TYPE_2,
    "TYPE 2 AC": Type.TYPE_2_AC,
    "Type 2 Plug": Type.TYPE_2_PLUG
});

enum VehicleType { THE_4_W, THE_2_W_3_W_4_W, THE_2_W_3_W }

final vehicleTypeValues = EnumValues({
    "['2W', '3W']": VehicleType.THE_2_W_3_W,
    "['2W', '3W', '4W']": VehicleType.THE_2_W_3_W_4_W,
    "['4W']": VehicleType.THE_4_W
});

enum VendorName { GENSOL_CHARGE_PVT_LTD, REIL, BLU_SMART, SMART_E, EEE, HPCL, BSES, PLUG_NGO, TPDDL, REVOS, E_FILL_ELECTRIC, POWERBANK, BLUSMART, PVT_LTD, JIO_BP, SUN_MOBILITY, JBM_RENEWABLES, BATTERY_SMART }

final vendorNameValues = EnumValues({
    "BatterySmart": VendorName.BATTERY_SMART,
    "BLUSMART": VendorName.BLUSMART,
    "BluSmart": VendorName.BLU_SMART,
    "BSES": VendorName.BSES,
    "EEE": VendorName.EEE,
    "E-Fill Electric": VendorName.E_FILL_ELECTRIC,
    "GensolCharge Pvt. Ltd.": VendorName.GENSOL_CHARGE_PVT_LTD,
    "HPCL": VendorName.HPCL,
    "JBM Renewables": VendorName.JBM_RENEWABLES,
    "Jio-bp": VendorName.JIO_BP,
    "PlugNgo": VendorName.PLUG_NGO,
    "Powerbank": VendorName.POWERBANK,
    "Pvt. Ltd.": VendorName.PVT_LTD,
    "REIL": VendorName.REIL,
    "REVOS": VendorName.REVOS,
    "Smart E": VendorName.SMART_E,
    "Sun Mobility": VendorName.SUN_MOBILITY,
    "TPDDL": VendorName.TPDDL
});

enum Zone { CENTRAL_DELHI, NORTH_WEST_DELHI, NORTH_DELHI, EAST_DELHI, SOUTH_DELHI, WEST_DELHI, SOUTH_WEST_DELHI, NORTH_EAST_DELHI }

final zoneValues = EnumValues({
    "central-delhi": Zone.CENTRAL_DELHI,
    "east-delhi": Zone.EAST_DELHI,
    "north-delhi": Zone.NORTH_DELHI,
    "north-east-delhi": Zone.NORTH_EAST_DELHI,
    "north-west-delhi": Zone.NORTH_WEST_DELHI,
    "south-delhi": Zone.SOUTH_DELHI,
    "south-west-delhi": Zone.SOUTH_WEST_DELHI,
    "west-delhi": Zone.WEST_DELHI
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
