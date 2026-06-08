python-base-mode

(imp "import " p)
(from "from " (p "module") " import " q)
(as "import " (p "module") " as " q)

(def "def " (p "name") "(" p "):" n> r>)
(adef "async def " (p "name") "(" p "):" n> r>)
(lambda "lambda " p ": " q)

(class "class " (p "Name") ":" n> q)
(init "def __init__(self" p "):" n> q)
(main "def main() -> None:" n> r> n n
      "if __name__ == \"__main__\":" n>
      "main()")

(if "if " p ":" n> r>)
(ife "if " p ":" n> r> n "else:" n> q)
(elif "elif " p ":" n> q)

(for "for " (p "item") " in " (p "items") ":" n> r>)
(while "while " p ":" n> r>)
(with "with " p " as " q ":" n> r>)
(awith "async with " p " as " q ":" n> r>)

(try "try:" n> r> n "except " (p "Exception") " as " (p "exc") ":" n> q)
(tryf "try:" n> r> n "finally:" n> q)
(raise "raise " p)

(listcomp "[" (p "expr") " for " (p "item") " in " (p "items") "]")
(dictcomp "{" (p "key") ": " (p "value") " for " (p "item") " in " (p "items") "}")

(prop "@property" n "def " (p "name") "(self):" n> q)
(setter "@" (p "name") ".setter" n "def " name "(self, " (p "value") "):" n> q)

(dataclass "@dataclass" n "class " (p "Name") ":" n> q)
(test "def test_" p "():" n> q)
