;;; ellama.el -*- lexical-binding: t; -*-

(use-package ellama
        :init
        ;; language you want ellama to translate to
        (setopt ellama-language "English")
        ;;(setopt ellama-keymap-prefix "<leader> c g") ;; <leader> doesn't work
        (setopt ellama-enable-keymap t)
        ;; could be llm-openai for example
        (require 'llm-ollama)
        (setopt ellama-provider
                        (make-llm-ollama
                        :chat-model "phind-codellama"
                        :embedding-model "phind-codellama"))
        (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
        (setopt ellama-providers
                        '(("phind-codellama" . (make-llm-ollama
                                        :chat-model "phind-codellama"
                                        :embedding-model "phind-codellama"))
                        ("codebooga" . (make-llm-ollama
                                        :chat-model "codebooga"
                                        :embedding-model "codebooga"))
                        ("deepseek-coder" . (make-llm-ollama
                                        :chat-model "deepseek-coder"
                                        :embedding-model "deepseek-coder"))
                        ("phi" . (make-llm-ollama
                                        :chat-model "phi"
                                        :embedding-model "phi"))
                        ("wizardlm-uncensored" . (make-llm-ollama
                                        :chat-model "wizardlm-uncensored"
                                        :embedding-model "wizardlm-uncensored"))
                        ;; ("" . (make-llm-ollama
                        ;;                 :chat-model ""
                        ;;                 :embedding-model ""))
                        ))
)
