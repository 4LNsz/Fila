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
local function Teams(Table, Amount, Sides)
    local Groups = {} -- Grupos que estão na fila
    local Return = {} -- Grupos que estão selecionados

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
        local Side = 1
        local Temporary = Sides

        -- Loop para que o grupo verifique todas as possibilidades de ingressar nos lados disponibilizados
        repeat
            local Random = math.random(#Temporary)
            local Selected = Sides[Random]
            local Size = 0

            if Selected then
                for _, _ in pairs(Return[Selected]["players"]) do
                    Size += 1
                end

                if Amount - Size >= Groups[Number]["Size"] then
                    Side = Selected
                    Accept = true
                else
                    Temporary[Random] = nil
                end
            end
        until Accept or #Temporary <= 0

        -- Apenas grupos que se encaixam nos parâmetros irão entrar no lado definido
        if Accept then
            for _, v in pairs(Table[Groups[Number]["Name"]]["players"]) do
                Return[Side]["players"][#Return[Side]["players"] + 1] = v
            end

            Table[Groups[Number]["Name"]] = nil
        end
    end

    -- DEBUG
    -- print("Tabela com os lados definidos: " .. json.encode(Return))
    -- print("Grupos que ficaram na Queue: " .. json.encode(Table))

    return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXECUTE
-----------------------------------------------------------------------------------------------------------------------------------------
-- Tabela da Queue (como é uma variável de constante alteração, irá ser utilizado ela no estado em que for executado)
-- Quantidade de jogadores por time
-- Lados que serão distrubuídos
Teams(Queue, 5, { "attackers", "defenders" })
