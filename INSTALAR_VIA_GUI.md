# 📦 Como Instalar o Plugin via Interface Gráfica do Archi

## ✅ Arquivo Pronto

O arquivo `.archiplugin` foi criado com sucesso:

```
📦 Arquivo: com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
💾 Tamanho: 43K
📍 Localização: /home/victor/Projetos/VH System/archi-auto-label-config/
```

---

## 🚀 Como Instalar (Passo a Passo)

### Passo 1: Abrir o Archi

Certifique-se de que o Archi está aberto.

### Passo 2: Acessar o Gerenciador de Plugins

No Archi, vá em:

```
Help → Manage Plug-ins...
```

Ou use o atalho do menu:

```
Menu Principal → Help → Manage Plug-ins...
```

### Passo 3: Instalar Novo Plugin

1. Na janela "Manage Plug-ins", clique no botão **"Install New..."** (Instalar Novo...)

2. Uma janela de seleção de arquivo será aberta

3. Navegue até o arquivo:
   ```
   /home/victor/Projetos/VH System/archi-auto-label-config/
   ```

4. Selecione o arquivo:
   ```
   com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin
   ```

5. Clique em **"Open"** ou **"Abrir"**

### Passo 4: Confirmar Instalação

1. O Archi irá analisar o plugin

2. Uma mensagem de confirmação será exibida

3. Clique em **"OK"** ou **"Install"** para confirmar

### Passo 5: Reiniciar o Archi

1. O Archi pedirá para reiniciar

2. Clique em **"Restart Now"** (Reiniciar Agora)

3. O Archi irá fechar e abrir novamente automaticamente

---

## ✅ Verificar Instalação

Após reiniciar, verifique se o plugin foi instalado:

### Opção 1: Via Menu

Vá em **Tools** no menu principal. Você deve ver a opção:
```
Tools → Manage Default Labels
```

### Opção 2: Via Lista de Plugins

1. **Help → About Archi**
2. Clique em **"Installation Details"**
3. Na aba **"Plug-ins"**, procure por:
   ```
   com.vhsystem.defaultlabel
   ```

---

## 🧪 Testar o Plugin

### Teste do Bug Corrigido

1. **Tools → Manage Default Labels**

2. Anote o valor atual de um elemento (ex: "Application Collaboration")

3. Altere o valor para algo diferente

4. Clique em **OK**

5. Quando aparecer o diálogo "Update Existing Elements?", clique em **No**

6. ✅ **Abra novamente o diálogo**: O valor deve ter voltado ao original!

### Comportamento Esperado

| Ação | Resultado Esperado |
|------|-------------------|
| Alterar + OK + No | ✅ Valor volta ao original (BUG CORRIGIDO) |
| Alterar + OK + Yes | ✅ Valor salvo + elementos atualizados |
| Sem alterar + OK | ✅ Fecha sem perguntar nada |

---

## 🔧 Resolução de Problemas

### Problema: "Arquivo não é um plugin válido"

**Solução:** O arquivo pode estar corrompido. Recrie-o:
```bash
cd '/home/victor/Projetos/VH System/archi-auto-label-config'
./scripts/create_archiplugin.sh
```

### Problema: Plugin não aparece no menu Tools

**Solução:**
1. Verifique se o plugin foi instalado: **Help → About Archi → Installation Details**
2. Se não aparecer, tente reinstalar
3. Certifique-se de ter reiniciado o Archi

### Problema: Erro ao instalar

**Solução:**
1. Feche completamente o Archi
2. Remova plugins antigos:
   ```bash
   rm -rf ~/.archi/plugins/com.vhsystem.defaultlabel*
   ```
3. Abra o Archi novamente
4. Tente instalar novamente via GUI

---

## 📋 Informações do Plugin

| Item | Valor |
|------|-------|
| **Nome** | Default Label Plugin |
| **ID** | com.vhsystem.defaultlabel |
| **Versão** | 1.0.0.qualifier |
| **Arquivo** | com.vhsystem.defaultlabel_1.0.0.qualifier.archiplugin |
| **Tamanho** | 43 KB |
| **Correção** | Bug de inconsistência no cancelamento |

---

## 🎯 Resumo

1. ✅ Plugin removido da instalação manual
2. ✅ Arquivo `.archiplugin` criado
3. 📍 Localização do arquivo pronta
4. 📖 Instruções de instalação via GUI prontas

**Próximo passo:** Instale via **Help → Manage Plug-ins... → Install New...**

---

## 📞 Precisa de Ajuda?

Se encontrar qualquer problema durante a instalação:

1. Consulte a seção "Resolução de Problemas" acima
2. Verifique os logs do Archi: `~/.archi/.metadata/.log`
3. Consulte: `BUG_CORRIGIDO_PRONTO.md` para mais detalhes

---

**Data de Criação:** 10/11/2025  
**Versão do Plugin:** 1.0.0.qualifier  
**Versão do Archi:** 5.6.0

