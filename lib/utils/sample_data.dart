import '../models/plant.dart';
import '../models/category.dart';

List<Category> sampleCategories = [
  Category(
    id: 1,
    name: 'Indoor Plants',
    icon: '🏠',
    description: 'Perfect for home and office environments',
  ),
  Category(
    id: 2,
    name: 'Outdoor Plants',
    icon: '🌳',
    description: 'Beautiful plants for gardens and balconies',
  ),
  Category(
    id: 3,
    name: 'Succulents',
    icon: '🌵',
    description: 'Low-maintenance plants with unique shapes',
  ),
  Category(
    id: 4,
    name: 'Flowering Plants',
    icon: '🌸',
    description: 'Colorful blooms to brighten your space',
  ),
  Category(
    id: 5,
    name: 'Herbs',
    icon: '🌿',
    description: 'Culinary and medicinal herbs',
  ),
];

List<Plant> samplePlants = [
  Plant(
    id: 1,
    name: 'Snake Plant',
    scientificName: 'Sansevieria trifasciata',
    description:
        'A hardy indoor plant known for its air-purifying qualities and low maintenance. Also called Mother-in-Law\'s Tongue.',
    imageUrl:
        '../assets/images/Snake.png',
    careInstructions: [
      'Water every 2-3 weeks, allowing soil to dry out between waterings.',
      'Prefers indirect sunlight but can tolerate low light.',
      'Use well-draining soil to prevent root rot.',
      'Dust leaves regularly for optimal health.',
    ],
    categoryId: 1,
    watering: 'Every 2-3 weeks',
    sunlight: 'Indirect light',
    soil: 'Well-draining potting mix',
  ),
  Plant(
    id: 2,
    name: 'Peace Lily',
    scientificName: 'Spathiphyllum',
    description:
        'An elegant plant with white flowers, excellent for improving indoor air quality. Known for its air-purifying abilities.',
    imageUrl:
        'https://americanplantexchange.com/cdn/shop/products/peacelily-1.jpg?v=1672881763&width=990',
    careInstructions: [
      'Keep soil moist but not waterlogged.',
      'Thrives in low to medium light.',
      'Fertilize monthly during growing season.',
      'Wipe leaves to remove dust.',
    ],
    categoryId: 1,
    watering: 'Keep soil moist',
    sunlight: 'Low to medium light',
    soil: 'Rich, well-draining soil',
  ),
  Plant(
    id: 3,
    name: 'Spider Plant',
    scientificName: 'Chlorophytum comosum',
    description:
        'A resilient plant that produces plantlets, great for beginners. Known for its spider-like offshoots.',
    imageUrl:
        'https://roguehome.com.au/cdn/shop/files/yxojjcm3lpyvydstkhcp.jpg?v=1751348985&width=1780',
    careInstructions: [
      'Water when top soil is dry.',
      'Bright indirect light preferred.',
      'Regular potting soil works well.',
      'Propagate from plantlets.',
    ],
    categoryId: 1,
    watering: 'When top soil dry',
    sunlight: 'Bright indirect',
    soil: 'Regular potting soil',
  ),
  Plant(
    id: 4,
    name: 'Aloe Vera',
    scientificName: 'Aloe barbadensis miller',
    description:
        'A medicinal succulent with healing gel inside its leaves. Perfect for burns and skin care.',
    imageUrl:
        'https://roguehome.com.au/cdn/shop/files/79.286.12_001.jpg?v=1751349888&width=1780',
    careInstructions: [
      'Water deeply but infrequently.',
      'Bright, direct sunlight.',
      'Sandy, well-draining soil.',
      'Protect from frost.',
    ],
    categoryId: 3,
    watering: 'Every 2-3 weeks',
    sunlight: 'Bright direct light',
    soil: 'Sandy, well-draining',
  ),
  Plant(
    id: 5,
    name: 'Basil',
    scientificName: 'Ocimum basilicum',
    description:
        'Aromatic herb used in cooking. Easy to grow indoors or outdoors.',
    imageUrl:
        '../assets/images/Basil.png',
    careInstructions: [
      'Water regularly, keep soil moist.',
      'Full sun to partial shade.',
      'Well-draining potting soil.',
      'Pinch flowers to encourage leaf growth.',
    ],
    categoryId: 5,
    watering: 'Regular, keep moist',
    sunlight: 'Full sun',
    soil: 'Well-draining potting mix',
  ),
  Plant(
    id: 6,
    name: 'Rose',
    scientificName: 'Rosa',
    description:
        'Classic flowering plant symbolizing love. Requires regular care but rewards with beautiful blooms.',
    imageUrl:
        'https://images.contentstack.io/v3/assets/bltcedd8dbd5891265b/blt78239e1e4521271c/6668d549ee20f576046dca5c/4738613-Red-Roses-Hero.jpg',
    careInstructions: [
      'Water deeply 2-3 times per week.',
      'Full sun required.',
      'Fertilize during growing season.',
      'Prune regularly for shape.',
    ],
    categoryId: 4,
    watering: '2-3 times per week',
    sunlight: 'Full sun',
    soil: 'Rich, well-draining',
  ),
  Plant(
    id: 7,
    name: 'Lavender',
    scientificName: 'Lavandula',
    description:
        'Fragrant herb with purple flowers. Perfect for gardens and aromatherapy.',
    imageUrl:
        '../assets/images/Lavender.png',
    careInstructions: [
      'Water sparingly once established.',
      'Full sun essential.',
      'Poor, well-draining soil.',
      'Prune after flowering.',
    ],
    categoryId: 5,
    watering: 'Sparingly',
    sunlight: 'Full sun',
    soil: 'Poor, well-draining',
  ),
  Plant(
    id: 8,
    name: 'Jade Plant',
    scientificName: 'Crassula ovata',
    description:
        'Lucky plant also known as money tree. Very low maintenance succulent.',
    imageUrl:
        'https://ucarecdn.com/b8a7cd75-09ba-44f3-ae42-ca759a429b75/-/format/auto/-/preview/3000x3000/-/quality/lighter/ISS_3483_12683.jpg',
    careInstructions: [
      'Water when soil is completely dry.',
      'Bright light, some direct sun.',
      'Cactus or succulent soil.',
      'Repot every 2-3 years.',
    ],
    categoryId: 3,
    watering: 'When soil dry',
    sunlight: 'Bright light',
    soil: 'Cactus/succulent mix',
  ),
  Plant(
    id: 9,
    name: 'Sunflower',
    scientificName: 'Helianthus annuus',
    description:
        'Tall flowering plant that follows the sun. Great for gardens and cut flowers.',
    imageUrl:
        'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?w=400',
    careInstructions: [
      'Water regularly, keep soil moist.',
      'Full sun required.',
      'Fertilize every 2 weeks.',
      'Stake tall varieties.',
    ],
    categoryId: 4,
    watering: 'Regular, keep moist',
    sunlight: 'Full sun',
    soil: 'Rich, well-draining',
  ),
  Plant(
    id: 10,
    name: 'Mint',
    scientificName: 'Mentha',
    description:
        'Refreshing herb used in teas and cooking. Grows quickly and can be invasive.',
    imageUrl:
        'https://nurserylive.com/cdn/shop/products/nurserylive-g-mexican-mint-patharchur-ajwain-leaves-plant_600x600_b19dd3a5-22ed-4495-88d9-c6662276b46b.jpg?v=1751599687',
    careInstructions: [
      'Keep soil consistently moist.',
      'Partial shade to full sun.',
      'Rich, moist soil.',
      'Grow in containers to control spread.',
    ],
    categoryId: 5,
    watering: 'Keep moist',
    sunlight: 'Partial shade',
    soil: 'Rich, moist',
  ),
];
