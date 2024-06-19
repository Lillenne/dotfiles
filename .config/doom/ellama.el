;;; ellama.el -*- lexical-binding: t; -*-

;; must call ollama pull {models}
(use-package ellama
        :init
        ;; language you want ellama to translate to
        (setopt ellama-language "English")
        (setopt ellama-keymap-prefix "C-S-e")
        (setopt ellama-enable-keymap t)
        ;; could be llm-openai for example
        (require 'llm-ollama)
        (setopt ellama-provider
                        (make-llm-ollama
                        :chat-model "llama3"
                        :embedding-model "llama3"))
        (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
        (setopt ellama-providers
                        '(("deepseek-coder:33b" . (make-llm-ollama
                                        :chat-model "deepseek-coder:33b"
                                        :embedding-model "deepseek-coder:33b"))
                        ("llama3" . (make-llm-ollama
                                        :chat-model "llama3"
                                        :embedding-model "llama3"))
                        ))
)
