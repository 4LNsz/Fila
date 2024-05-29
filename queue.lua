-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
Queue = {
    ['group:1'] = {
        players = {
            [1] = {
                nick = 'ViperGT',
                leader = true
            }
        }
    },
    ['group:2'] = {
        players = {
            [1] = {
                nick = 'NeonSpectre',
                leader = false
            },
            [2] = {
                nick = 'DriftKing',
                leader = true
            },
            [3] = {
                nick = 'DriftKing',
                leader = true
            },
            [4] = {
                nick = 'DriftKing',
                leader = true
            },
            [5] = {
                nick = 'DriftKing',
                leader = true
            }
        }
    },
    ['group:3'] = {
        players = {
            [2] = {
                nick = 'NeonSpectre',
                leader = false
            },
            [3] = {
                nick = 'DriftKing',
                leader = true
            },
            [8] = {
                nick = 'NeonSpectre',
                leader = false
            },
            [9] = {
                nick = 'DriftKing',
                leader = true
            }
        }
    },
    ['group:4'] = {
        players = {
            [2] = {
                nick = 'BlazeGamer',
                leader = false
            },
            [3] = {
                nick = 'SpeedRacer',
                leader = false
            },
            [4] = {
                nick = 'ShadowNinja',
                leader = true
            },
            [5] = {
                nick = 'PhoenixFire',
                leader = false
            }
        }
    },
    ['group:5'] = {
        players = {
            [2] = {
                nick = 'BlazeGamer',
                leader = false
            }
        }
    },
    ['group:6'] = {
        players = {
            [6] = {
                nick = 'ThunderBolt',
                leader = true
            },
            [7] = {
                nick = 'GhostRider',
                leader = false
            }
        }
    },
    ['group:7'] = {
        players = {
            [1] = {
                nick = 'BlazeGamer',
                leader = false
            },
            [2] = {
                nick = 'BlazeGamer',
                leader = false
            }
        }
    },
    ['group:8'] = {
        players = {
            [1] = {
                nick = 'BlazeGamer',
                leader = false
            },
            [2] = {
                nick = 'BlazeGamer',
                leader = false
            },
            [3] = {
                nick = 'BlazeGamer',
                leader = false
            }
        }
    },
    ['group:9'] = {
        players = {
            [8] = {
                nick = 'NeonSpectre',
                leader = false
            },
            [9] = {
                nick = 'DriftKing',
                leader = true
            }
        }
    },
    ['group:10'] = {
        players = {
            [10] = {
                nick = 'MidnightWolf',
                leader = true
            }
        }
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEAMS
-----------------------------------------------------------------------------------------------------------------------------------------
local function Teams(Table, Amount)
    local Groups = {}                          -- Grupos que estão na fila
    local Sides = { "attackers", "defenders" } -- Lados que serão posicionados # TODO para implementar mais lados
    local Return = {}

    -- Geração dos lados
    for Number = 1, #Sides do
        Return[Sides[Number]] = {
            players = {}
        }
    end

    -- Nova tabela com o nome do grupo e quantidade dos jogadores para comparação
    for Name in pairs(Table) do
        local Size = 0

        for Index, _ in pairs(Table[Name]["players"]) do
            Size += 1

            Table[Name]["players"][Index]["group"] = Name
        end

        Groups[#Groups + 1] = { Name = Name, Size = Size }
    end

    -- Organizar a tabela por quantidade de jogadores no grupo
    table.sort(Groups, function(a, b) return a.Size > b.Size end)

    -- Organizar os times
    for Number = 1, #Groups do
        local Accept = false
        local Side = Sides[math.random(#Sides)]
        local Size = 0

        for _, _ in pairs(Return[Side]["players"]) do
            Size += 1
        end

        if Amount - Size < Groups[Number]["Size"] then
            if Side == "attackers" then
                Side = "defenders"
            else
                Side = "attackers"
            end

            -- Resetar contagem do lado
            Size = 0

            for _, _ in pairs(Return[Side]["players"]) do
                Size += 1
            end

            if Amount - Size >= Groups[Number]["Size"] then
                Accept = true
            end
        else
            Accept = true
        end

        -- Apenas grupos que se encaixam nos parâmetros irão entrar no lado definido
        if Accept then
            for Index, v in pairs(Table[Groups[Number]["Name"]]["players"]) do
                Return[Side]["players"][#Return[Side]["players"] + 1] = v
            end

            Table[Groups[Number]["Name"]] = nil
        end
    end

    -- DEBUG
    print("Tabela com os lados definidos: " .. json.encode(Return))
    print("Grupos que ficaram na Queue: " .. json.encode(Table))

    return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE
-----------------------------------------------------------------------------------------------------------------------------------------
Teams(Queue, 5) -- Tabela da Queue, Quantidade de jogadores por time (podendo ser expandido para quaisquer valores)
