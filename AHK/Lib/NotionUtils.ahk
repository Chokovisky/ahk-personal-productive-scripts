; ==============================================================================
; Lib/NotionUtils.ahk
; DESCRIÇÃO: Utilitários específicos para o Notion (atalhos, automações)
; ==============================================================================

;; Função para garantir que o comando vá apenas para o Notion
Notion_ToggleAllToggles() {
    if WinActive("ahk_exe Notion.exe") {
        Send("^!t") ; Envia Ctrl + Alt + T (Nativo do Notion para Expand/Collapse All)
    } else {
        ; Opcional: Traz o Notion para frente e executa
        try {
            WinActivate("ahk_exe Notion.exe")
            WinWaitActive("ahk_exe Notion.exe",, 1)
            Send("^!t")
        }
    }
}

; ==============================================================================
; WATCHER: Clipboard → Obsidian deeplink (somente quando Notion está ativo)
; ==============================================================================
; Cenário:
; - No Notion Desktop, você clica no botão de copiar que joga um obsidian://... no clipboard.
; - Quando isso acontece, e a janela ativa é o Notion, abrimos diretamente o Obsidian.
; - Se o clipboard mudar em qualquer outro app, ignoramos.
;
; Uso:
; - Chamar Notion_StartObsidianClipboardWatcher() uma vez (por exemplo, no auto-start do Launcher).
; ==============================================================================

Notion_StartObsidianClipboardWatcher() {
    static started := false
    if (started)
        return
    started := true

    ; Registra callback global para mudanças no clipboard
    OnClipboardChange(Notion_OnClipboardChange_Obsidian)
}

Notion_OnClipboardChange_Obsidian(clipboardType) {
    ; 1 = texto em AHK v2
    if (clipboardType != 1)
        return

    ; Garante que só reage quando o Notion estiver ativo
    if !WinActive("ahk_exe Notion.exe")
        return

    text := A_Clipboard
    ; Em AHK v2, A_Clipboard já é texto quando clipboardType = 1, só checamos vazio
    if (text = "")
        return
 
    ; Procura por um obsidian:// contínuo (sem espaços) no texto
    if !RegExMatch(text, "obsidian://\S+", &m)
        return

    uri := m[0]

    ; Execução protegida – se der erro, simplesmente ignora
    try Run uri
}

;; Placeholder futura função de "Registrar Sessão de Estudo"
; Notion_LogStudySession() {
;     ; Aqui entra o script futuro para logar sessões de estudo no Notion
; }

;; Placeholder futura função de "Inserção Rápida"
; Notion_QuickInsert() {
;     ; Aqui entra o script futuro para inserção rápida no Notion
; }   

; ==============================================================================
; FIM DO ARQUIVO: Lib/NotionUtils.ahk
; ==============================================================================