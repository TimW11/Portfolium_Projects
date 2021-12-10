class GameBoard
    attr_reader :max_row, :max_column

    def initialize(max_row, max_column)
        @max_row = max_row
        @max_column = max_column

        @board = [[]]
        @hits = 0
        @remaining = 0

        for i in 0...max_row 
            r = [""]
            for j in 0...max_column
                r.push("-")
            end
            @board.push(r)
        end
    end

    # adds a Ship object to the GameBoard
    # returns Boolean
    # Returns true on successfully added the ship, false otherwise
    # Note that Position pair starts from 1 to max_row/max_column
    def add_ship(ship)
        start = ship.start_position


        orientation = ship.orientation
        size = ship.size
        x = start.row
        y = start.column

        if x < 1 || y < 1 || x > @max_row || y > @max_column || @board[x][y] != "-" || size < 1 || size > 5
            return false
        end

        locations = [start]
        if orientation == "Up"

            for i in 1 ... size do 
                x -= 1
                if x < 1 || @board[x][y] != "-"
                    return false
                end
                locations.push(Position.new(x,y))
            end

        elsif orientation == "Down"
            for i in 1 ... size do 
                x += 1
                if x > @max_row || @board[x][y] != "-"
                    return false
                end
                locations.push(Position.new(x,y))
            end
        elsif orientation == "Left"
            for i in 1 ... size do 
                y -= 1
                if y < 1 || @board[x][y] != "-"
                    return false
                end
                locations.push(Position.new(x,y))
            end
        elsif orientation == "Right"
            for i in 1 ... size do 
                y += 1
                if y > @max_column || @board[x][y] != "-"
                    return false
                end
                locations.push(Position.new(x,y))
            end
        end

        for i in 0 ... locations.length
            current = locations[i]
            @board[current.row][current.column] = "B"
        end

        @remaining += size
        return true
    end

    # return Boolean on whether attack was successful or not (hit a ship?)
    # return nil if Position is invalid (out of the boundary defined)
    def attack_pos(position)
        x = position.row
        y = position.column

        if x < 1 || y < 1 || y > @max_column || x > @max_row
            return nil
        end

        if @board[x][y] == "-"
            return false
        elsif @board[x][y] == "B"
            @remaining -= 1
            @hits += 1
            @board[x][y] = "X"
        end

        return true
    end

    # Number of successful attacks made by the "opponent" on this player GameBoard
    def num_successful_attacks
        return @hits
    end

    # returns Boolean
    # returns True if all the ships are sunk.
    # Return false if at least one ship hasn't sunk.
    def all_sunk?
        if @remaining == 0 
            return true
        end

        return false
    end


    # String representation of GameBoard (optional but recommended)
    def to_s
        for i in 0..@max_row 
            for j in 1..@max_column
                print "  #{@board[i][j]}  |"
            end
            puts ""
        end
    end
end