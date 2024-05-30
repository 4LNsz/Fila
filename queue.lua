-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE
-----------------------------------------------------------------------------------------------------------------------------------------
Queue = {
    ['group:1'] = {
        players = {
            ["1"] = {
                nick = 'ViperGT',
                leader = true
            }
        }
    },
    ['group:4'] = {
        players = {
            ["2"] = {
                nick = 'BlazeGamer',
                leader = false
            },
            ["3"] = {
                nick = 'SpeedRacer',
                leader = false
            },
            ["4"] = {
                nick = 'ShadowNinja',
                leader = true
            },
            ["5"] = {
                nick = 'PhoenixFire',
                leader = false
            },
            ["6"] = {
                nick = 'ThunderBolt',
                leader = true
            }
        }
    },
    ['group:9'] = {
        players = {
            ["8"] = {
                nick = 'NeonSpectre',
                leader = false
            },
            ["9"] = {
                nick = 'DriftKing',
                leader = true
            },
            ["10"] = {
                nick = 'MidnightWolf',
                leader = true
            },
            ["11"] = {
                nick = 'MidnightWolf',
                leader = true
            }
        }
    },
    ['group:10'] = {
        players = {
            ["12"] = {
                nick = 'MidnightWolf',
                leader = true
            },
            ["7"] = {
                nick = 'GhostRider',
                leader = false
            }
        }
    }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- COUNTTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function CountTable(Table)
    local Return = 0

    for _, _ in pairs(Table) do
        Return += 1
    end

    return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECOUNTTABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local function RecountTable(Table)
    local Return = {}

    for Number = 1, #Table do
        if Table[Number] then Return[#Return + 1] = Table[Number] end
    end

    return Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MATCHES
-----------------------------------------------------------------------------------------------------------------------------------------
---@param Table table   -- Tabela da fila
---@param Sides table   -- Uma lista de lados em que as equipes podem ser divididas (por exemplo, atacantes e defensores)
---@param Amount number -- A quantidade desejada de jogadores por equipe
---@return boolean out  -- Variável onde informa se todos os grupos foram preenchidos
---@return table out    -- Tabela com os lados definidos e os jogadores selecionados
-- TODO: Adicionar parâmetros de matchmaking conforme pontuação
local function Matches(Table, Sides, Amount)
    local Groups = {}   -- Grupos que estão na fila
    local Return = {}   -- Grupos que estão selecionados
    local Match = true

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
        local Side = false
        local Store = {}

        -- Loop para guardar em cache os valores padrões, para não serem alterados no loop abaixo
        for Index = 1, #Sides do
            Store[Index] = Sides[Index]
        end

        -- Loop para que o grupo verifique todas as possibilidades de ingressar nos lados disponibilizados
        repeat
            Store = RecountTable(Store)

            local Random = math.random(#Store)
            local Selected = Store[Random]
            local Size = 0

            if Selected then
                for _, _ in pairs(Return[Selected]["players"]) do
                    Size += 1
                end

                if Amount - Size >= Groups[Number]["Size"] then
                    Side = Selected
                else
                    Store[Random] = nil -- Remoção do lado, para que no próximo loop não caia novamente, já que não há vaga para esse grupo
                end
            end
        until Side or #Store <= 0

        -- Apenas grupos que se encaixam nos parâmetros irão entrar no lado selecionado, caso contrário ficam na fila
        if Side then
            for Index, Player in pairs(Table[Groups[Number]["Name"]]["players"]) do
                Return[Side]["players"][Index] = Player
            end
        end
    end

    -- Verificação de todos os lados foram preenchidos
    for Side, v in pairs(Return) do
        if CountTable(v["players"]) < Amount then
            Match = false

            break
        end
    end

    -- Caso possuir todos os lados preenchidos, os grupos serão removidos da fila
    if Match then
        for Side in pairs(Return) do
            for Index in pairs(Return[Side]["players"]) do
                if Table[Return[Side]["players"][Index]["group"]] then
                    Table[Return[Side]["players"][Index]["group"]] = nil
                end
            end
        end
    end

    -- DEBUGS
    print("Todos os lados foram preenchidos: " .. json.encode(Match))
    print("Tabela com os lados definidos: " .. json.encode(Return))
    print("Grupos que ficaram na Queue: " .. json.encode(Table))

    return Match, Return
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- EXAMPLE
-----------------------------------------------------------------------------------------------------------------------------------------
local Match, Teams = Matches(Queue, { "attackers", "defenders" }, 5)