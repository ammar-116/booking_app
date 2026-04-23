import '../models/room.dart';

class RoomService {
  static List<Room> getRooms() {
    return [
      // ─── ISLAMABAD ───────────────────────────────────────────
      Room(
        id: "ISB-D1",
        type: "Deluxe",
        city: "Islamabad",
        price: 12000,
        address: "House 4, Street 12, F-6/3, Islamabad",
        description:
            "A spacious deluxe room with king-size bed, hardwood flooring, and floor-to-ceiling windows overlooking the Margalla Hills. Furnished with a writing desk, wardrobe, and a plush reading chair.",
        facilities: [
          "WiFi",
          "AC",
          "Geyser",
          "TV",
          "Mini Fridge",
          "Room Service",
        ],
      ),
      Room(
        id: "ISB-D2",
        type: "Deluxe",
        city: "Islamabad",
        price: 12000,
        address: "Flat 3B, Margalla View Apartments, F-10, Islamabad",
        description:
            "Modern deluxe room with premium furnishings, double bed with orthopedic mattress, and a private balcony. Tastefully decorated with warm lighting and contemporary artwork.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "Balcony", "Mini Fridge"],
      ),
      Room(
        id: "ISB-S1",
        type: "Standard",
        city: "Islamabad",
        price: 8000,
        address: "House 7, Street 3, G-9/2, Islamabad",
        description:
            "A comfortable standard room with a double bed, clean en-suite bathroom, and ample natural light. Simple, well-kept furnishings ideal for business or leisure travellers.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),
      Room(
        id: "ISB-R1",
        type: "Regular",
        city: "Islamabad",
        price: 5000,
        address: "House 14, Street 9, I-8/1, Islamabad",
        description:
            "A cozy regular room with a single bed, clean shared bathroom, and basic furnishings. Great value for budget-conscious travellers visiting the capital.",
        facilities: ["WiFi", "Fan", "Geyser"],
      ),

      // ─── LAHORE ──────────────────────────────────────────────
      Room(
        id: "LHR-D1",
        type: "Deluxe",
        city: "Lahore",
        price: 12000,
        address: "12 Gulberg III, Main Boulevard, Lahore",
        description:
            "Elegant deluxe room in the heart of Gulberg, featuring a king-size bed, Persian-inspired decor, marble flooring, and a luxurious en-suite with a rainfall shower.",
        facilities: [
          "WiFi",
          "AC",
          "Geyser",
          "TV",
          "Mini Fridge",
          "Room Service",
          "Parking",
        ],
      ),
      Room(
        id: "LHR-D2",
        type: "Deluxe",
        city: "Lahore",
        price: 12000,
        address: "45 DHA Phase 5, Block L, Lahore",
        description:
            "Sophisticated deluxe room in DHA with rich wooden furnishings, queen-size bed, walk-in wardrobe, and a serene garden view. Perfect for extended stays.",
        facilities: [
          "WiFi",
          "AC",
          "Geyser",
          "TV",
          "Garden View",
          "Mini Fridge",
        ],
      ),
      Room(
        id: "LHR-S1",
        type: "Standard",
        city: "Lahore",
        price: 8000,
        address: "House 3, Johar Town Block Q, Lahore",
        description:
            "Well-appointed standard room with a comfortable double bed, work desk, and private bathroom. Located in the calm residential area of Johar Town.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),
      Room(
        id: "LHR-R1",
        type: "Regular",
        city: "Lahore",
        price: 5000,
        address: "Room 5, Garhi Shahu, Lahore",
        description:
            "A budget-friendly regular room near the old city, offering a single bed, clean shared facilities, and easy access to Lahore's historic landmarks.",
        facilities: ["WiFi", "Fan", "Shared Bathroom"],
      ),

      // ─── KARACHI ─────────────────────────────────────────────
      Room(
        id: "KHI-D1",
        type: "Deluxe",
        city: "Karachi",
        price: 12000,
        address: "Flat 12, Clifton Block 5, Karachi",
        description:
            "Seaside deluxe room in Clifton with panoramic sea views, king-size bed, modern furnishings, and a private lounge area. A premium Karachi experience.",
        facilities: [
          "WiFi",
          "AC",
          "Geyser",
          "TV",
          "Sea View",
          "Mini Fridge",
          "Room Service",
        ],
      ),
      Room(
        id: "KHI-D2",
        type: "Deluxe",
        city: "Karachi",
        price: 12000,
        address: "Suite 3, Sea View Apartments, Bath Island, Karachi",
        description:
            "Luxurious suite-style deluxe room in Bath Island with contemporary decor, plush queen-size bed, and a spacious bathroom with a bathtub.",
        facilities: [
          "WiFi",
          "AC",
          "Geyser",
          "TV",
          "Bathtub",
          "Mini Fridge",
          "Parking",
        ],
      ),
      Room(
        id: "KHI-S1",
        type: "Standard",
        city: "Karachi",
        price: 8000,
        address: "House 19, Block 2, PECHS, Karachi",
        description:
            "Clean and comfortable standard room in PECHS with a double bed, air conditioning, and private bathroom. Centrally located with easy city access.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),
      Room(
        id: "KHI-R1",
        type: "Regular",
        city: "Karachi",
        price: 5000,
        address: "Room 3, Liaquatabad Block 6, Karachi",
        description:
            "Affordable regular room in Liaquatabad with basic furnishings, single bed, and shared bathroom. Ideal for short stays on a budget.",
        facilities: ["Fan", "Shared Bathroom", "WiFi"],
      ),

      // ─── MULTAN ──────────────────────────────────────────────
      Room(
        id: "MLT-D1",
        type: "Deluxe",
        city: "Multan",
        price: 10000,
        address: "House 5, Gulgasht Colony, Multan",
        description:
            "Warmly decorated deluxe room inspired by Multani tile art, featuring a king-size bed, private bathroom, and a spacious sitting area. A cultural stay in the City of Saints.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "Mini Fridge"],
      ),
      Room(
        id: "MLT-S1",
        type: "Standard",
        city: "Multan",
        price: 7000,
        address: "House 17, Shah Rukn-e-Alam Colony, Multan",
        description:
            "Comfortable standard room near Shah Rukn-e-Alam shrine with a double bed, en-suite bathroom, and simple tasteful decor.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),
      Room(
        id: "MLT-R1",
        type: "Regular",
        city: "Multan",
        price: 4500,
        address: "Room 4, Hussain Agahi Bazaar Area, Multan",
        description:
            "Simple and affordable room in the bazaar area, perfect for travellers exploring Multan's shrines and markets on a budget.",
        facilities: ["Fan", "Shared Bathroom", "WiFi"],
      ),

      // ─── PESHAWAR ────────────────────────────────────────────
      Room(
        id: "PSW-D1",
        type: "Deluxe",
        city: "Peshawar",
        price: 10000,
        address: "House 3, University Town, Peshawar",
        description:
            "Refined deluxe room in University Town with Pashtun-inspired wooden furnishings, a king-size bed, and a private courtyard view. Rich in character and comfort.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "Mini Fridge", "Parking"],
      ),
      Room(
        id: "PSW-S1",
        type: "Standard",
        city: "Peshawar",
        price: 7000,
        address: "House 8, Gulbahar Colony, Peshawar",
        description:
            "Clean standard room in Gulbahar with solid wooden furniture, a comfortable double bed, and an attached bathroom with hot water.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),
      Room(
        id: "PSW-R1",
        type: "Regular",
        city: "Peshawar",
        price: 4500,
        address: "Room 2, Qissa Khwani Bazaar Area, Peshawar",
        description:
            "A budget stay near the historic Qissa Khwani Bazaar. Simple furnishings, single bed, and shared facilities in the heart of old Peshawar.",
        facilities: ["Fan", "Shared Bathroom", "WiFi"],
      ),

      // ─── QUETTA ──────────────────────────────────────────────
      Room(
        id: "QTA-D1",
        type: "Deluxe",
        city: "Quetta",
        price: 10000,
        address: "House 7, Satellite Town, Quetta",
        description:
            "Spacious deluxe room in Quetta's Satellite Town with thick-walled construction for natural insulation, king-size bed, and warm Balochi textile accents throughout.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "Heater", "Mini Fridge"],
      ),
      Room(
        id: "QTA-S1",
        type: "Standard",
        city: "Quetta",
        price: 7000,
        address: "House 12, Jinnah Town, Quetta",
        description:
            "Comfortable standard room in Jinnah Town with a double bed, private bathroom, and a heater for Quetta's cool evenings. Clean and well-maintained.",
        facilities: ["WiFi", "Heater", "Geyser", "TV"],
      ),

      // ─── BAHAWALPUR ──────────────────────────────────────────
      Room(
        id: "BWP-D1",
        type: "Deluxe",
        city: "Bahawalpur",
        price: 9000,
        address: "House 2, Model Town A, Bahawalpur",
        description:
            "Regal deluxe room inspired by Bahawalpur's princely heritage, featuring ornate wooden furnishings, a king-size bed, and rich fabric drapes. A stay fit for royalty.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "Mini Fridge"],
      ),
      Room(
        id: "BWP-S1",
        type: "Standard",
        city: "Bahawalpur",
        price: 6500,
        address: "House 9, Satellite Town, Bahawalpur",
        description:
            "Neat standard room in Satellite Town with double bed, clean attached bathroom, and decent furnishings. A reliable stay in the heart of southern Punjab.",
        facilities: ["WiFi", "AC", "Geyser", "TV"],
      ),

      // ─── MURREE ──────────────────────────────────────────────
      Room(
        id: "MRE-D1",
        type: "Deluxe",
        city: "Murree",
        price: 14000,
        address: "The Pines Cottage, Mall Road, Murree",
        description:
            "Charming mountain deluxe room with pine-wood panelled walls, a stone fireplace, cozy king-size bed, and breathtaking views of the misty Murree hills.",
        facilities: ["WiFi", "Heater", "Fireplace", "TV", "Geyser", "Balcony"],
      ),
      Room(
        id: "MRE-S1",
        type: "Standard",
        city: "Murree",
        price: 9000,
        address: "Hilltop Rest House, GPO Chowk, Murree",
        description:
            "Cozy standard room with wooden flooring, a comfortable double bed, electric heater, and a window view of the pine forest. Perfect for a hill station retreat.",
        facilities: ["WiFi", "Heater", "Geyser", "TV"],
      ),

      // ─── ABBOTTABAD ──────────────────────────────────────────
      Room(
        id: "ABT-D1",
        type: "Deluxe",
        city: "Abbottabad",
        price: 11000,
        address: "3 Shimla Hill Road, Abbottabad",
        description:
            "Elegant deluxe room in a colonial-era bungalow style with high ceilings, antique wooden furniture, king-size bed, and a wraparound veranda overlooking the valley.",
        facilities: [
          "WiFi",
          "Heater",
          "Geyser",
          "TV",
          "Veranda",
          "Mini Fridge",
        ],
      ),
      Room(
        id: "ABT-S1",
        type: "Standard",
        city: "Abbottabad",
        price: 7500,
        address: "Sajid Guest House, Jinnah Abad, Abbottabad",
        description:
            "Clean and comfortable standard room with a double bed, attached bathroom, and garden access. A relaxed stay in the cool Hazara air.",
        facilities: ["WiFi", "Heater", "Geyser", "TV", "Garden Access"],
      ),

      // ─── SWAT ────────────────────────────────────────────────
      Room(
        id: "SWT-D1",
        type: "Deluxe",
        city: "Swat",
        price: 13000,
        address: "Riverside Lodge, Mingora, Swat",
        description:
            "Stunning riverside deluxe room with floor-to-ceiling windows framing the Swat River, natural stone flooring, king-size bed, and hand-woven Swati textiles throughout.",
        facilities: ["WiFi", "Heater", "Geyser", "TV", "River View", "Balcony"],
      ),
      Room(
        id: "SWT-S1",
        type: "Standard",
        city: "Swat",
        price: 8500,
        address: "Green Valley Inn, Fizagat, Swat",
        description:
            "Peaceful standard room surrounded by fruit orchards, featuring a double bed, private bathroom, and a small sitting area. A gentle Swat Valley experience.",
        facilities: ["WiFi", "Heater", "Geyser", "TV", "Garden View"],
      ),

      // ─── SKARDU ──────────────────────────────────────────────
      Room(
        id: "SKD-D1",
        type: "Deluxe",
        city: "Skardu",
        price: 15000,
        address: "Karakoram View Hotel, Airport Road, Skardu",
        description:
            "Premium deluxe room with jaw-dropping views of the Karakoram range, king-size bed with wool blankets, traditional Balti wooden ceiling, and a private heated bathroom.",
        facilities: [
          "WiFi",
          "Heater",
          "Geyser",
          "TV",
          "Mountain View",
          "Room Service",
        ],
      ),
      Room(
        id: "SKD-S1",
        type: "Standard",
        city: "Skardu",
        price: 9000,
        address: "Shangrila Guest House, Kachura Road, Skardu",
        description:
            "Comfortable standard room near the famous Shangrila Resort, with a double bed, private bathroom, and large windows looking out to the Indus valley.",
        facilities: ["WiFi", "Heater", "Geyser", "TV"],
      ),

      // ─── GILGIT ──────────────────────────────────────────────
      Room(
        id: "GLT-D1",
        type: "Deluxe",
        city: "Gilgit",
        price: 13000,
        address: "Serena Hotel Road, Jutial, Gilgit",
        description:
            "Sophisticated deluxe room in Gilgit's premium district, with mountain-facing windows, king-size bed, handcrafted local furniture, and a warm heated en-suite.",
        facilities: [
          "WiFi",
          "Heater",
          "Geyser",
          "TV",
          "Mountain View",
          "Mini Fridge",
        ],
      ),
      Room(
        id: "GLT-S1",
        type: "Standard",
        city: "Gilgit",
        price: 8000,
        address: "Park Avenue Guest House, Bank Road, Gilgit",
        description:
            "A solid standard room in central Gilgit with double bed, clean bathroom, and easy access to the bazaar and KKH. Reliable and value-driven.",
        facilities: ["WiFi", "Heater", "Geyser", "TV"],
      ),

      // ─── HUNZA ───────────────────────────────────────────────
      Room(
        id: "HNZ-D1",
        type: "Deluxe",
        city: "Hunza",
        price: 16000,
        address: "Eagle's Nest Diran, Duikar, Hunza",
        description:
            "Possibly Pakistan's most scenic deluxe room — perched above the valley with unobstructed views of Rakaposhi and Ultar Sar. King-size bed, stone walls, and a private terrace.",
        facilities: [
          "WiFi",
          "Heater",
          "Geyser",
          "TV",
          "Terrace",
          "Mountain View",
          "Room Service",
        ],
      ),
      Room(
        id: "HNZ-S1",
        type: "Standard",
        city: "Hunza",
        price: 10000,
        address: "Old Hunza Inn, Karimabad, Hunza",
        description:
            "Charming standard room in historic Karimabad with traditional Hunzai decor, double bed, private bathroom, and a rooftop terrace view of Baltit Fort.",
        facilities: ["WiFi", "Heater", "Geyser", "Rooftop Access"],
      ),

      // ─── BALAKOT ─────────────────────────────────────────────
      Room(
        id: "BLK-D1",
        type: "Deluxe",
        city: "Balakot",
        price: 11000,
        address: "Kunhar Riverside Retreat, Main Balakot Road",
        description:
            "Peaceful deluxe room on the banks of the Kunhar River, featuring a king-size bed, natural stone decor, river-facing balcony, and a fireplace for cool evenings.",
        facilities: [
          "WiFi",
          "Heater",
          "Fireplace",
          "Geyser",
          "TV",
          "River View",
          "Balcony",
        ],
      ),
      Room(
        id: "BLK-R1",
        type: "Regular",
        city: "Balakot",
        price: 5000,
        address: "Naran Road Budget Stay, Balakot",
        description:
            "Simple and clean regular room for travellers passing through Balakot en route to Naran. Single bed, shared bathroom, and hot water.",
        facilities: ["Fan", "Shared Bathroom", "Geyser"],
      ),

      // ─── CHILAS ──────────────────────────────────────────────
      Room(
        id: "CHL-D1",
        type: "Deluxe",
        city: "Chilas",
        price: 12000,
        address: "Indus View Hotel, KKH, Chilas",
        description:
            "Dramatic deluxe room on the Karakoram Highway with a view of the mighty Indus River gorge. King-size bed, heavy drapes, and traditional Diamer wooden accents.",
        facilities: ["WiFi", "AC", "Geyser", "TV", "River View", "Parking"],
      ),
      Room(
        id: "CHL-R1",
        type: "Regular",
        city: "Chilas",
        price: 4500,
        address: "Highway Rest Stop, KKH Chilas",
        description:
            "No-frills regular room for KKH travellers needing a night's rest. Clean single bed, shared bathroom, and hot water. Gets you ready for the road ahead.",
        facilities: ["Fan", "Shared Bathroom", "Geyser"],
      ),

      // ─── CHITRAL ─────────────────────────────────────────────
      Room(
        id: "CTR-D1",
        type: "Deluxe",
        city: "Chitral",
        price: 12000,
        address: "Tirich Mir View Hotel, Shahi Qila Road, Chitral",
        description:
            "Breathtaking deluxe room with a direct view of Tirich Mir, the world's highest Hindu Kush peak. King-size bed, Chitrali wooden carvings, and wool-insulated walls.",
        facilities: [
          "WiFi",
          "Heater",
          "Geyser",
          "TV",
          "Mountain View",
          "Room Service",
        ],
      ),
      Room(
        id: "CTR-R1",
        type: "Regular",
        city: "Chitral",
        price: 4500,
        address: "Bazaar Road Guest Room, Chitral",
        description:
            "Basic and warm regular room in Chitral town. Single bed with thick wool blankets, shared bathroom with hot water. A humble base for Kalash valley explorations.",
        facilities: ["Heater", "Shared Bathroom", "Geyser"],
      ),
    ];
  }
}
