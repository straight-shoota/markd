module Markd::Rule
  class BlockQuote
    include Rule

    def match(parser : Lexer, container : Node)
      if match?(parser)
        seek(parser)
        parser.close_unmatched_blocks
        parser.add_child(Node::Type::BlockQuote, parser.next_nonspace)

        MatchValue::Container
      else
        MatchValue::None
      end
    end

    def continue(parser : Lexer, container : Node)
      if match?(parser)
        seek(parser)
      else
        return 1
      end

      0
    end

    def token(parser : Lexer, container : Node)
      # do nothing
    end

    def can_contain(type : Node::Type) : Bool
      type != Node::Type::Item
    end

    def accepts_lines?
      false
    end

    private def match?(parser)
      !parser.indented && char_code(parser) == Rule::CHAR_CODE_GREATERTHAN
    end

    private def seek(parser : Lexer)
      parser.advance_next_nonspace
      parser.advance_offset(1, false)

      if space_or_tab?(char_code(parser, parser.offset))
        parser.advance_offset(1, true)
      end
    end
  end
end
