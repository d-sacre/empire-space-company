class_name GAME_PARAMETERS

class EXTREMA:
    class ENERGY: 
        const MINIMUM = 0.00
        const MAXIMUM = 800.00 # 800.00

    class ATMOSPHERE:
        class O2:
            const MINIMUM = Gas.O2.min
            const MAXIMUM = Gas.O2.max

        class CO2:
            const MINIMUM = Gas.CO2.min
            const MAXIMUM = Gas.CO2.max

    class PRODUCTIVITY:
        const MINIMUM = 0.00
        const MAXIMUM = 1.00

    class WEAR:
        const MINIMUM = 0.00
        const MAXIMUM = 1.00
    
    class WORKERS:
        const TOTAL = 3

    class ROCKET:
        class WEIGHT:
            class GROSS:
                const MAXIMUM = 150.00
            const NET = 100.00

    class MACHINE_SPEED:
        const MINIMUM = 0.50
        const MAXIMUM = 2.00

class START:
    const ENERGY = EXTREMA.ENERGY.MAXIMUM
    const PRODUCTIVITY = EXTREMA.PRODUCTIVITY.MAXIMUM
    const WEAR = EXTREMA.WEAR.MINIMUM
    const MACHINE_SPEED = 1.0
    
    class ATMOSPHERE:
        const O2 = EXTREMA.ATMOSPHERE.O2.MAXIMUM
        const CO2 = EXTREMA.ATMOSPHERE.CO2.MINIMUM

    class INVENTORY: 
        class ORE: 
            const CALORICUM = 0.00
            const POTASSIUM = 0.00
            const COPPER = 0.00
        
        const DECARBONIZER = 5.00

class GOALS:
    class MINING:
        class COPPER:
            const ORE = 2 # 15
