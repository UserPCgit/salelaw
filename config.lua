Config = {}

Config.Debug = true
Config.ReOnboardingAfterDays = 30
Config.TeleportReturningPlayers = true
Config.OnboardingVersion = 1

Config.Commands = {
    OpenTutorial = "tutorial",
    ChangeDepartment = "department",
    ResetOnboarding = "resetonboarding"
}

Config.Marker = {
    DrawDistance = 25.0,
    InteractDistance = 1.8,
    Type = 1,
    Scale = vector3(1.15, 1.15, 0.35),
    Color = { r = 35, g = 145, b = 255, a = 150 }
}

Config.Keys = { Interact = 38 } -- E

-- Replace coordinates with your real MLO/interior coordinates later.
Config.Factions = {
    law = {
        label = "Law Enforcement",
        description = "Police, sheriff, state and federal agencies.",
        active = true,
        categories = {
            blaine = {
                label = "Blaine County",
                description = "Sheriff, highway patrol and ranger services.",
                active = true,
                departments = {
                    bcso = {
                        label = "Blaine County Sheriff's Office",
                        short = "BCSO",
                        active = true,
                        spawn = vector4(1856.0, 3682.0, 34.0, 210.0),
                        departmentServices = vector3(1852.0, 3689.0, 34.0),
                        dutyDesk = vector3(1852.0, 3689.0, 34.0),
                        locker = vector3(1848.0, 3685.0, 34.0),
                        armory = vector3(1845.0, 3680.0, 34.0),
                        garage = vector4(1866.0, 3677.0, 33.0, 210.0),
                        divisions = {
                            patrol = { label = "Patrol Division", active = true, specializations = { general = { label = "General Patrol", active = true } } }
                        },
                        vehicles = {
                            { label = "Sheriff Cruiser", model = "sheriff" },
                            { label = "Sheriff SUV", model = "sheriff2" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT", "WEAPON_NIGHTSTICK" }
                    },
                    lssd = {
                        label = "Los Santos Sheriff's Department",
                        short = "LSSD",
                        active = true,
                        spawn = vector4(1856.0, 3682.0, 34.0, 210.0),
                        departmentServices = vector3(1852.0, 3689.0, 34.0),
                        dutyDesk = vector3(1852.0, 3689.0, 34.0),
                        locker = vector3(1848.0, 3685.0, 34.0),
                        armory = vector3(1845.0, 3680.0, 34.0),
                        garage = vector4(1866.0, 3677.0, 33.0, 210.0),
                        divisions = {
                            patrol = { label = "Patrol Division", active = true, specializations = { general = { label = "General Patrol", active = true } } }
                        },
                        vehicles = {
                            { label = "Sheriff Cruiser", model = "sheriff" },
                            { label = "Sheriff SUV", model = "sheriff2" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT", "WEAPON_NIGHTSTICK" }
                    },
                    sahp = {
                        label = "San Andreas Highway Patrol",
                        short = "SAHP",
                        active = true,
                        spawn = vector4(825.0, -1290.0, 28.0, 90.0),
                        departmentServices = vector3(825.0, -1290.0, 28.0),
                        dutyDesk = vector3(825.0, -1290.0, 28.0),
                        locker = vector3(820.0, -1292.0, 28.0),
                        armory = vector3(817.0, -1296.0, 28.0),
                        garage = vector4(835.0, -1280.0, 27.0, 90.0),
                        divisions = {
                            highway = { label = "Highway Patrol", active = true, specializations = { general = { label = "General Highway Patrol", active = true } } }
                        },
                        vehicles = {
                            { label = "Highway Cruiser", model = "police" },
                            { label = "Highway SUV", model = "police2" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT", "WEAPON_NIGHTSTICK" }
                    },
                    park_ranger = {
                        label = "Park Ranger",
                        short = "RANGER",
                        active = true,
                        spawn = vector4(386.0, 795.0, 187.0, 180.0),
                        departmentServices = vector3(386.0, 795.0, 187.0),
                        dutyDesk = vector3(386.0, 795.0, 187.0),
                        locker = vector3(388.0, 791.0, 187.0),
                        armory = vector3(391.0, 789.0, 187.0),
                        garage = vector4(380.0, 799.0, 186.0, 180.0),
                        divisions = {
                            ranger = { label = "Ranger Patrol", active = true, specializations = { general = { label = "General Ranger Patrol", active = true } } }
                        },
                        vehicles = { { label = "Park Ranger SUV", model = "pranger" } },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT", "WEAPON_NIGHTSTICK" }
                    }
                }
            },
            los_santos = {
                label = "Los Santos City",
                description = "City police operations.",
                active = true,
                departments = {
                    lspd = {
                        label = "Los Santos Police Department",
                        short = "LSPD",
                        active = true,
                        spawn = vector4(441.0, -981.0, 30.0, 90.0),
                        departmentServices = vector3(441.0, -978.0, 30.0),
                        dutyDesk = vector3(441.0, -978.0, 30.0),
                        locker = vector3(452.0, -992.0, 30.0),
                        armory = vector3(482.0, -995.0, 30.0),
                        garage = vector4(454.0, -1017.0, 28.0, 90.0),
                        divisions = {
                            patrol = {
                                label = "Patrol Division",
                                active = true,
                                specializations = {
                                    general = { label = "General Patrol", active = true },
                                    k9 = { label = "K-9 Unit", active = false, status = "work_in_progress" },
                                    motorbike = { label = "Motorbike Patrol", active = false, status = "work_in_progress" },
                                    traffic = { label = "Traffic Unit", active = false, status = "work_in_progress" }
                                }
                            },
                            swat = {
                                label = "SWAT",
                                active = true,
                                specializations = {
                                    general = { label = "General SWAT", active = true },
                                    assault = { label = "Assault", active = false, status = "work_in_progress" },
                                    bomb_squad = { label = "Bomb Squad", active = false, status = "work_in_progress" }
                                }
                            },
                            detective = {
                                label = "Detective Bureau",
                                active = true,
                                specializations = { general = { label = "Detective", active = true } }
                            }
                        },
                        vehicles = {
                            { label = "Patrol Cruiser", model = "police" },
                            { label = "Patrol SUV", model = "police2" },
                            { label = "Unmarked", model = "police4" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT", "WEAPON_NIGHTSTICK" }
                    }
                }
            },
            federal = {
                label = "Federal Agent",
                description = "Federal investigations and operations.",
                active = true,
                departments = {
                    iaa = {
                        label = "International Affairs Agency",
                        short = "IAA",
                        active = true,
                        spawn = vector4(120.0, -620.0, 206.0, 90.0),
                        departmentServices = vector3(120.0, -620.0, 206.0),
                        dutyDesk = vector3(120.0, -620.0, 206.0),
                        locker = vector3(122.0, -622.0, 206.0),
                        armory = vector3(124.0, -624.0, 206.0),
                        garage = vector4(100.0, -620.0, 205.0, 90.0),
                        divisions = { field = { label = "Field Operations", active = true, specializations = { general = { label = "General Field Operations", active = true } } } },
                        vehicles = {
                            { label = "Unmarked Sedan", model = "fbi" },
                            { label = "Unmarked SUV", model = "fbi2" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT" }
                    },
                    fib = {
                        label = "Federal Investigation Bureau",
                        short = "FIB",
                        active = true,
                        spawn = vector4(136.0, -750.0, 258.0, 160.0),
                        departmentServices = vector3(136.0, -750.0, 258.0),
                        dutyDesk = vector3(136.0, -750.0, 258.0),
                        locker = vector3(138.0, -752.0, 258.0),
                        armory = vector3(140.0, -754.0, 258.0),
                        garage = vector4(145.0, -760.0, 257.0, 160.0),
                        divisions = { field = { label = "Field Operations", active = true, specializations = { general = { label = "General Field Operations", active = true } } } },
                        vehicles = {
                            { label = "FIB Buffalo", model = "fbi" },
                            { label = "FIB Granger", model = "fbi2" }
                        },
                        loadout = { "WEAPON_PISTOL", "WEAPON_STUNGUN", "WEAPON_FLASHLIGHT" }
                    }
                }
            }
        }
    },
    civil = {
        label = "Civil",
        description = "Civilian and public service roles.",
        active = true,
        departments = {
            mayor = { label = "Mayor", short = "MAYOR", active = true, spawn = vector4(-545.0, -204.0, 38.0, 210.0), departmentServices = vector3(-545.0, -204.0, 38.0) },
            firefighter = { label = "Firefighter", short = "FIRE", active = false, status = "work_in_progress" },
            ems = { label = "EMS", short = "EMS", active = false, status = "work_in_progress" }
        }
    },
    criminal = {
        label = "Criminal",
        description = "Criminal organizations and illegal factions.",
        active = true,
        departments = {
            bikers = { label = "Bikers", short = "BIKERS", active = false, status = "work_in_progress" },
            cartel = { label = "Cartel", short = "CARTEL", active = true, spawn = vector4(1391.0, 3606.0, 38.0, 200.0), departmentServices = vector3(1391.0, 3606.0, 38.0) },
            mafia = { label = "Mafia", short = "MAFIA", active = false, status = "work_in_progress" }
        }
    }
}
