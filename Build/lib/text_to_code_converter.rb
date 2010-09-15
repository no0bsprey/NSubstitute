﻿class TextToCodeConverter
    def initialize(extractor)
        @extractor = extractor
    end
    def convert(text)
        test_number = 0
        code_blocks = @extractor.extract(text)
        declarations = code_blocks.select { |x| declaration? x}.join("\n")
        tests = code_blocks
                    .select { |x| not declaration? x}
                    .map { |x| to_test(x, test_number += 1) }

        <<-EOF
using System;
using NUnit.Framework;
using System.Linq;
using System.Collections.Generic;

namespace NSubstitute.Documentation.Samples {
#{declarations}
#{tests}
}
        EOF
    end

    private
    def declaration?(code_block)
        code_block =~ /(public |private |protected )?(class|interface)/
    end

    def to_test(code_block, test_number)
        "[Test] public void Test_#{test_number} {
            #{code_block}
        }"
    end
end