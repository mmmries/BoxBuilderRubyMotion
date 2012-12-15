class BoardViewController < UIViewController
  SQUARE_SIZE = 40
  GRID_DIMENSIONS = [6,6]
  COLORS = [UIColor.greenColor, UIColor.redColor, UIColor.whiteColor]

  def viewDidLoad
    self.init_views
    self.new_game
    self.board_changed
  end

  def init_views
    view.backgroundColor = UIColor.blackColor
    # view for the board
    @board_view = UIView.alloc.initWithFrame([[0, 0], [SQUARE_SIZE * GRID_DIMENSIONS.first, SQUARE_SIZE * GRID_DIMENSIONS.last]])
    @board_view.center = view.center
    
    # views for the square
    @square_views = []
    for i in 0..(boxes_across-1)
      for j in 0..(boxes_down-1)
        square_view = UIView.alloc.initWithFrame([[j * (SQUARE_SIZE + 2), i * (SQUARE_SIZE + 2)], [SQUARE_SIZE - 4, SQUARE_SIZE - 4]])
        square_view.layer.cornerRadius = 5.0
        @square_views[i*(boxes_across) + j] = square_view
        @board_view.addSubview(square_view)
      end
    end
    
    # label for game information
    @label = UILabel.alloc.initWithFrame([[0, 0], [0, 0]])
    @label.textColor = UIColor.whiteColor
    @label.font = UIFont.systemFontOfSize(30)
    @label.backgroundColor = nil
    
    view.addSubview(@label)
    view.addSubview(@board_view)
  end

  def show_info(text)
    @label.text = text
    @label.sizeToFit
    @label.center = [160, 50]
  end
  
  def new_game
    # initalize the game
    @board = Board.new(GRID_DIMENSIONS)
    @current_player = 0
  end

  def boxes_across
    GRID_DIMENSIONS.first
  end

  def boxes_down
    GRID_DIMENSIONS.last
  end

  def total_boxes
    GRID_DIMENSIONS.inject(1){|sum,dim| sum *= dim }
  end
  
  def touchesEnded(touches, withEvent:event)
    # check if we're touching a square
    for i in 0..(total_boxes-1)
      if event.touchesForView(@square_views[i])
        if not @board.move(i, @current_player) then 
          show_info("Illegal move!")
          break
        end
        
        @current_player += 1
        @current_player %= 2
        break
      end
    end
    
    # check if the game is over
    if winner = @board.game_over?
      @board.reset
      if winner == -1
        show_info("No one wins!")
      elsif winner
        show_info("Player #{winner + 1} wins!")
      end
    end
    
    self.board_changed
  end
  
  # update the square views
  def board_changed
    for i in 0..(total_boxes-1)
      @square_views[i].backgroundColor = COLORS[@board.grid[i]]
    end
  end
end
