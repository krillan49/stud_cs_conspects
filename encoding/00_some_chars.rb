# https://symbl.cc/en/unicode-table/#box-drawing

puts %w[░ ▒ ▓ █ ▀ ▄ ▌ ▐ ─]

puts %w[━ ┃ ┏ ┓ ┗ ┛ ┣ ┫ ┳ ┻ ╋]


# Проверить разные символы chr(Encoding::UTF_8)
(0..0x10FFFF).each.with_index do |codepoint, i|
  puts codepoint.chr(Encoding::UTF_8) if i > 9590 && i < 9610
end

# Название символов:
# ~ - тильда
# ^ - карет
# & - и
# | - или
# \ - бэкслэш
# / - слэш
