<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" method="text" indent="no" use-character-maps="ampersand"/>
    
    <xsl:character-map name="ampersand">
        <xsl:output-character character="&amp;" string="+"/>
    </xsl:character-map>
    
    <xsl:template match="/">
        \documentclass[12pt,a4paper]{scrbook}
        \usepackage{polyglossia}
        \usepackage{fontspec}
        \usepackage{libertine}
        \usepackage{xcolor}
        \usepackage{cancel}
        \usepackage{scrlayer-scrpage}
        \cehead{Cinzia Grifoni}
        \cohead{The Wissembourg Priscian Glosses}
        \setmainlanguage{english}
        \setotherlanguage[variant=ancient]{greek}
        \newfontfamily\greekfont[ExternalLocation="./"]{SBL_BLit.ttf}
        \parindent0pt
        \begin{document}
        <xsl:apply-templates select="child::node()"/>
        \end{document}
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:apply-templates select="child::node()[not(tei:facsimile)]"/>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        \begin{titlepage}
        \author{\textsc{<xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:editor/text()"/>}}
        \title{\textbf{The Wissembourg Priscian Glosses}}
        \date{Vienna, 25.06.2025}
        \end{titlepage}
    </xsl:template>
    
    <xsl:template match="tei:text">
        <xsl:apply-templates select="child::tei:body"/>
    </xsl:template>
    
    <xsl:template match="tei:body">
        \maketitle
        \tableofcontents
        \part{Introduction}
        \part{Transcription and Analysis}
        <xsl:apply-templates select="child::tei:div"/>
    </xsl:template>
    
    <xsl:template match="tei:div[parent::tei:body]">
        <xsl:apply-templates select="child::tei:div[@type = 'page-of-Hertz-edition'][not(exists(@prev))]"/>
    </xsl:template>
    
    <xsl:template match="tei:div[@type = 'page-of-Hertz-edition'][not(exists(@prev))]">
        \chapter*{<xsl:value-of select="@n"/>}\addcontentsline{toc}{chapter}{<xsl:value-of select="@n"/>}
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="(local-name(following-sibling::*[1]) = 'div') and exists(following-sibling::*[1][@type = 'page-of-Hertz-edition'][exists(@prev)])">
            <xsl:apply-templates select="following-sibling::*[1]"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:div[@type = 'page-of-Hertz-edition'][exists(@prev)]">
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="(local-name(following-sibling::*[1]) = 'div') and exists(following-sibling::*[1][@type = 'page-of-Hertz-edition'][exists(@prev)])">
            <xsl:apply-templates select="following-sibling::*[1]"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:value-of select="@n"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="text()[parent::tei:quote and not(exists(parent::tei:quote/parent::tei:add/parent::tei:rdg))]">
        <xsl:text>\textbf{</xsl:text>
            <xsl:value-of select="."/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()[parent::tei:quote and exists(parent::tei:quote/parent::tei:add/parent::tei:rdg)]">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:lb[ancestor::tei:quote]">
        <xsl:text>\textit{</xsl:text>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@ed"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>) </xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:if test="not(local-name(following-sibling::*[1]) = 'supplied')">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="for $x in (1 to @quantity) return '.'"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:quote and not(exists(parent::tei:quote/parent::tei:add/parent::tei:rdg))]">
        <xsl:text>\textbf{</xsl:text>
            <xsl:text> 〈</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:if test="exists(@resp)">
                <xsl:text> - </xsl:text>
                <xsl:choose>
                    <xsl:when test="@resp = 'scr-1'">
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>main scribe</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="@resp = 'scr'">
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>main scribe</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="@resp = 'sec'">
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>secondary scribe</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="@resp = 'Otfrid'">
                        <xsl:text>\textit{</xsl:text>
                        <xsl:value-of select="'Otfrid'"/>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="@resp = 'gl-1'">
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>first glossator</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:when test="@resp = 'gl-2'">
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>second glossator</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>\textit{</xsl:text>
                            <xsl:text>C. G.</xsl:text>
                        <xsl:text>}</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:text>〉</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:quote and exists(parent::tei:quote/parent::tei:add/parent::tei:rdg)]">
        <xsl:text> 〈</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:if test="exists(@resp)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="@resp = 'scr-1'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>main scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'scr'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>main scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'sec'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>secondary scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'Otfrid'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:value-of select="'Otfrid'"/>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-1'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>first glossator</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-2'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>second glossator</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>C. G.</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:add/parent::tei:rdg]">
        <xsl:text>〈</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:if test="exists(@resp)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="@resp = 'scr-1'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>main scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'scr'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>main scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'sec'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>secondary scribe</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'Otfrid'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:value-of select="'Otfrid'"/>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-1'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>first glossator</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-2'">
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>second glossator</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>\textit{</xsl:text>
                    <xsl:text>C. G.</xsl:text>
                    <xsl:text>}</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:quote]">
        <xsl:text>\textbf{</xsl:text>
            <xsl:value-of select="text()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:quote]">
        <xsl:text>\textbf{\textit{</xsl:text>
            <xsl:apply-templates/>
        <xsl:text>}}</xsl:text>
        <xsl:text>\textit{</xsl:text>
            <xsl:text> (</xsl:text>
            <xsl:if test="exists(child::tei:hi)">
                <xsl:value-of select="child::tei:hi/@rend"/>
            </xsl:if>
            <span class="set-margin-left-and-right"><i class="far fa-hand-paper"></i></span>
            <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                <xsl:text>main scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'sec'">
                <xsl:text>secondary scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
                <xsl:text>first glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:text>second glossator</xsl:text>
            </xsl:if>
            <xsl:text>)</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="(@rend = 'red capitalis') or (@rend = 'red capitalis rustica') or (@rend = 'red script') or (@rend = 'letter filled with red ink') or (@rend = 'capital letter filled with red ink')">
                <xsl:text>{\textcolor[HTML]{9E1B16}</xsl:text>
                    <xsl:apply-templates/>
            <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="@rend = 'bold'">
                <xsl:text>\textbf{</xsl:text>
                    <xsl:apply-templates/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:when test="@rend = 'italic'">
                <xsl:text>\textit{</xsl:text>
                    <xsl:apply-templates/>
                <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:if test="exists(parent::tei:quote)">
            <xsl:text>\textbf{</xsl:text>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>)</xsl:text>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(parent::tei:quote))">
            <xsl:text>\textbf{</xsl:text>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>)</xsl:text>
           <xsl:text>}\par </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'text-variation']">
        <xsl:text>Text variation: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
        <xsl:apply-templates select="tei:lem | tei:rdg"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'reference-signs']">
        <xsl:text>Reference sign: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
            <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
        <xsl:apply-templates select="tei:lem"/>
        <xsl:apply-templates select="tei:rdg"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'emendation']">
        <xsl:text>Emendation: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
        <xsl:apply-templates select="tei:lem"/>
        <xsl:apply-templates select="tei:rdg" mode="emendation"/>
        <xsl:text>\par </xsl:text>
        <xsl:apply-templates select="tei:note"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="emendation">
        <xsl:text>\hspace{10mm}</xsl:text>
        <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
            <xsl:text>Codex 50</xsl:text>
        </xsl:if>
        <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
            <xsl:value-of select="substring-after(@wit,'#')"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del[@type = 'expunction']">
        <xsl:text>\cancel{</xsl:text>
            <xsl:value-of select="text()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del[not(@type = 'expunction') and (@cause = 'emendation')]">
        <xsl:text>\cancel{</xsl:text>
            <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg/parent::tei:app[@type = 'emendation']]">
        <xsl:text> 〈</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>〉</xsl:text>
        <xsl:text> [</xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:text> - Hand: </xsl:text>
        <xsl:if test="exists(@hand)">
            <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                <xsl:text>main scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'sec'">
                <xsl:text>secondary scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
                <xsl:text>first glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:text>second glossator</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="not(exists(@hand))">
            <xsl:if test="substring-after(parent::tei:rdg/@hand,'#') = 'scr-1' or substring-after(parent::tei:rdg/@hand,'#') = 'scr'">
                <xsl:text>main scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(parent::tei:rdg/@hand,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(parent::tei:rdg/@hand,'#') = 'sec'">
                <xsl:text>secondary scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(parent::tei:rdg/@hand,'#') = 'gl-1'">
                <xsl:text>first glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(parent::tei:rdg/@hand,'#') = 'gl-2'">
                <xsl:text>second glossator</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'gloss']">
        <xsl:text>Gloss: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
        <xsl:apply-templates select="tei:lem"/>
        <xsl:apply-templates select="tei:rdg"/>
        <xsl:text>\par </xsl:text>
        <xsl:apply-templates select="tei:note"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'annotation-signs']">
        <xsl:text>Annotation sign: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
            <xsl:apply-templates select="tei:lem"/>
            <xsl:apply-templates select="tei:rdg"/>
        <xsl:text>\par </xsl:text>
        <xsl:apply-templates select="tei:note"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'rubrication']">
        <xsl:text>Rubrication: </xsl:text>
        <xsl:text>\small\texttt{</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>}\normalsize\par </xsl:text>
        <xsl:apply-templates select="tei:lem"/>
        <xsl:apply-templates select="tei:rdg" mode="rubrication"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="rubrication">
        <xsl:text>\hspace{10mm}</xsl:text>
        <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
            <xsl:text>Codex 50</xsl:text>
        </xsl:if>
        <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
            <xsl:value-of select="substring-after(@wit,'#')"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text> [</xsl:text>
        <xsl:if test="count(child::tei:hi) gt 1">
            <xsl:for-each select="child::tei:hi">
                <xsl:value-of select="./@rend"/>
                <xsl:if test="position() != last()">
                    <xsl:text> - </xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="count(child::tei:hi) eq 1">
            <xsl:value-of select="child::tei:hi/@rend"/>
        </xsl:if>
        <xsl:text> - Hand: </xsl:text>
        <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
            <xsl:text>main scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
            <xsl:text>Otfrid</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'sec'">
            <xsl:text>secondary scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
            <xsl:text>first glossator</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
            <xsl:text>second glossator</xsl:text>
        </xsl:if>
        <xsl:text>]\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lem">
        <xsl:text>\hspace{10mm}</xsl:text>
        <xsl:if test="substring-after(@wit,'#') = 'EDITION'">
            <xsl:text>Edition</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
            <xsl:text>Codex 50</xsl:text>
        </xsl:if>
        <xsl:if test="not(substring-after(@wit,'#') = 'EDITION' or substring-after(@wit,'#') = 'COD_50')">
            <xsl:value-of select="substring-after(@wit,'#')"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <xsl:text>\hspace{10mm}</xsl:text>
        <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
            <xsl:text>Codex 50</xsl:text>
        </xsl:if>
        <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
            <xsl:value-of select="substring-after(@wit,'#')"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:if test="not(exists(text())) and not(exists(child::node()))">
        <xsl:text>\textit{</xsl:text>
            <xsl:text>omitted</xsl:text>
        <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="exists(child::tei:del) and exists(child::tei:add[@place = 'interlinear above']) and exists(child::tei:add[@place = 'interlinear above']/following-sibling::text())">
                <!-- construct text of reading -->
                <xsl:apply-templates select="tei:del | tei:add | text()" mode="reading-with-del-add-and-text"/>
                <!-- construct analytic information contained in tei:add -->
                <xsl:apply-templates select="tei:add" mode="insert-analytic-from-add"/>
           </xsl:when>
           <xsl:when test="not(exists(child::tei:del)) and exists(child::tei:add[@place = 'interlinear above']) and exists(child::tei:add[@place = 'interlinear above']/following-sibling::text())">
               <xsl:apply-templates select="tei:add | text()" mode="reading-with-del-add-and-text"/>
               <xsl:apply-templates select="tei:add" mode="insert-analytic-from-add"/>
           </xsl:when>
           <xsl:otherwise>
               <xsl:apply-templates/>
           </xsl:otherwise>
        </xsl:choose>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="reading-with-del-add-and-text">
        <xsl:text>\cancel{</xsl:text>
            <xsl:text> </xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text> </xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="reading-with-del-add-and-text">
        <xsl:text>⸌</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>⸍</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="reading-with-del-add-and-text">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="insert-analytic-from-add">
        <xsl:text>Location: </xsl:text>
            <xsl:value-of select="@place"/>
        <xsl:text>\par </xsl:text>
        <xsl:text>Hand: </xsl:text>
        <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
            <xsl:text>main scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
            <xsl:text>Otfrid</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'sec'">
            <xsl:text>secondary scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
            <xsl:text>first glossator</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
            <xsl:text>second glossator</xsl:text>
        </xsl:if>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg and not(parent::tei:rdg/parent::tei:app[@type = 'emendation'])]">
        <xsl:apply-templates/>
        <xsl:if test="exists(@xml:id)">
            <xsl:text> (</xsl:text>
            <xsl:text>\small\texttt{</xsl:text>
                <xsl:value-of select="@xml:id"/>
            <xsl:text>}\normalsize{}</xsl:text>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>\par </xsl:text>
        <xsl:text>Location: </xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:text>\par </xsl:text>
        <xsl:text>Hand: </xsl:text>
        <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
            <xsl:text>main scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
            <xsl:text>Otfrid</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'sec'">
            <xsl:text>secondary scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
            <xsl:text>first glossator</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
            <xsl:text>second glossator</xsl:text>
        </xsl:if>
        <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
        <xsl:if test="exists(@ana)">
            <xsl:for-each select="tokenize(@ana,'\s*#')">
                <xsl:if test=". != ''">
                    <xsl:text>\par </xsl:text>
                    <xsl:text>Analysis: </xsl:text>
                        <xsl:choose>
                            <xsl:when test="current() = 'glosses-on-prosody'"><xsl:text>glosses on prosody</xsl:text></xsl:when>
                            <xsl:when test="current() = 'length-mark'"><xsl:text>length mark</xsl:text></xsl:when>
                            <xsl:when test="current() = 'length-of-syllables'"><xsl:text>length of syllables</xsl:text></xsl:when>
                            <xsl:when test="current() = 'comment-on-metre'"><xsl:text>comment on metre</xsl:text></xsl:when>
                            <xsl:when test="current() = 'lexical glosses'"><xsl:text>lexical glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'translation-into-Old-High-German'"><xsl:text>translation into Old-High German</xsl:text></xsl:when>
                            <xsl:when test="current() = 'synonyms'"><xsl:text>synonyms</xsl:text></xsl:when>
                            <xsl:when test="current() = 'negated-antonyms'"><xsl:text>negated antonyms</xsl:text></xsl:when>
                            <xsl:when test="current() = 'definition-given-by-an-entire-sentence'"><xsl:text>definition given by an entire sentence</xsl:text></xsl:when>
                            <xsl:when test="current() = 'Greek-glosses'"><xsl:text>Greek glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'use-of-different-prefixes'"><xsl:text>use of different prefixes</xsl:text></xsl:when>
                            <xsl:when test="current() = 'adjectives-glossed-with-a-noun'"><xsl:text>adjectives glossed with a noun</xsl:text></xsl:when>
                            <xsl:when test="current() = 'differentiae'"><xsl:text>differentiae</xsl:text></xsl:when>
                            <xsl:when test="current() = 'further-derivations'"><xsl:text>further derivations</xsl:text></xsl:when>
                            <xsl:when test="current() = 'original-parts-of-a-word'"><xsl:text>original parts of a word</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses'"><xsl:text>grammatical glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-noun'"><xsl:text>grammatical glosses on the noun</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-pronoun'"><xsl:text>grammatical glosses on the pronoun</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-verb-participle-and-gerund'"><xsl:text>grammatical glosses on verb, participle and gerund</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-adverb'"><xsl:text>grammatical glosses on the adverb</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-conjunction'"><xsl:text>grammatical glosses on the conjunction</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-preposition'"><xsl:text>grammatical glosses on the preposition</xsl:text></xsl:when>
                            <xsl:when test="current() = 'grammatical-glosses-on-the-interjection'"><xsl:text>grammatical glosses on the interjection</xsl:text></xsl:when>
                            <xsl:when test="current() = 'syntactical-glosses'"><xsl:text>syntactical glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'syntactical-glosses-using-symbols'"><xsl:text>syntactical glosses using symbols</xsl:text></xsl:when>
                            <xsl:when test="current() = 'suppletive-glosses'"><xsl:text>suppletive glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-identifying-a-speaker-or-an-example'"><xsl:text>glosses identifying a speaker or an example</xsl:text></xsl:when>
                            <xsl:when test="current() = 'commentary-glosses'"><xsl:text>commentary glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-decoding-figures-of-speech'"><xsl:text>glosses decoding figures of speech</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-summarizing-content'"><xsl:text>glosses summarizing content</xsl:text></xsl:when>
                            <xsl:when test="current() = 'cross-references'"><xsl:text>cross references</xsl:text></xsl:when>
                            <xsl:when test="current() = 'elaborate-comment-on-the-main-text'"><xsl:text>elaborate comment on the main text</xsl:text></xsl:when>
                            <xsl:when test="current() = 'quia-glosses'"><xsl:text></xsl:text>quia glosses</xsl:when>
                            <xsl:when test="current() = 'glosses-elucidating-the-main-text'"><xsl:text>glosses elucidating the main text</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-elucidating-the-main-text-with-siglum-auctoris'"><xsl:text>glosses elucidating the main text with siglum auctoris</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-elucidating-the-main-text-with-a-title'"><xsl:text>glosses elucidating the main text with a title</xsl:text></xsl:when>
                            <xsl:when test="current() = 'glosses-elucidating-the-main-text-with-red-marginal-title'"><xsl:text>glosses elucidating the main text with red marginal title</xsl:text></xsl:when>
                            <xsl:when test="current() = 'etymological-glosses'"><xsl:text>etymological glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'encyclopedic-glosses'"><xsl:text>encyclopedic glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'geographical-names'"><xsl:text>geographical names</xsl:text></xsl:when>
                            <xsl:when test="current() = 'source-glosses'"><xsl:text>source glosses</xsl:text></xsl:when>
                            <xsl:when test="current() = 'source-or-comparison'"><xsl:text>source or comparison</xsl:text></xsl:when>
                            <xsl:when test="current() = 'acquaintance-with-classics'"><xsl:text>acquaintance with classics</xsl:text></xsl:when>
                            <xsl:when test="current() = 'text-variant'"><xsl:text>text variant</xsl:text></xsl:when>
                            <xsl:when test="current() = 'contemporary-socio-historical-context'"><xsl:text>contemporary socio historical context</xsl:text></xsl:when>
                            <xsl:when test="current() = 'lemma-gloss'"><xsl:text>Reference sign: lemma - gloss</xsl:text></xsl:when>
                            <xsl:when test="current() = 'lemma-lemma'"><xsl:text>Reference sign: lemma - lemma</xsl:text></xsl:when>
                            <xsl:when test="current() = 'attention-sign-nota'"><xsl:text>attention sign nota</xsl:text></xsl:when>
                            <xsl:when test="current() = 'excerption-signs'"><xsl:text>excerption signs</xsl:text></xsl:when>
                            <xsl:when test="current() = 'excerption-sign-inverted-paragraphus'"><xsl:text>excerption sign inverted paragraphus</xsl:text></xsl:when>
                            <xsl:when test="current() = 'capital-delta'"><xsl:text>capital delta</xsl:text></xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="replace(current(),'-',' ')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g">
        <xsl:choose>
            <xsl:when test="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/ancestor::tei:charDecl/@n = 'abbreviations'">
                <xsl:text>|</xsl:text>
                <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
                <xsl:text>|</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>|</xsl:text>
                    <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
                <xsl:text>|</xsl:text>
           </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:rdg]">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="tei:note[@type = 'explanation']">
        <xsl:text>Explanation:</xsl:text>
            <xsl:text>On </xsl:text>
            <xsl:if test="exists(@target)">
                <xsl:if test="contains(@target,' ')">
                    <xsl:for-each select="tokenize(@target,' ')">
                        <xsl:text>\texttt{</xsl:text>
                        <xsl:value-of select="substring-after(.,'#')"/>
                        <xsl:text>}</xsl:text>
                        <xsl:if test="position() != last()">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                   </xsl:for-each>
                </xsl:if>
                <xsl:if test="not(contains(@target,' '))">
                    <xsl:text>\texttt{</xsl:text>
                        <xsl:value-of select="substring-after(@target,'#')"/>
                    <xsl:text>}</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="not(exists(@target))">
                <xsl:if test="contains(@corresp,' ')">
                    <xsl:for-each select="tokenize(@corresp,' ')">
                        <xsl:text>\texttt{</xsl:text>
                            <xsl:value-of select="substring-after(.,'#')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        <xsl:text>}</xsl:text>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="not(contains(@corresp,' '))">
                    <xsl:text>\texttt{</xsl:text>
                        <xsl:value-of select="substring-after(@corresp,'#')"/>
                    <xsl:text>}</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates select="child::node()"/>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:note[@type = 'gloss']">
        <xsl:text>Note:</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>\par </xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:text>\par </xsl:text>
        <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
            <xsl:text>main scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
            <xsl:text>Otfrid</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'sec'">
            <xsl:text>secondary scribe</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
           <xsl:text>first glossator</xsl:text>
        </xsl:if>
        <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
             <xsl:text>second glossator</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
            <xsl:value-of select="parent::tei:rdg/parent::tei:app/tei:lem/text()"/>
            <xsl:text> &#8594; </xsl:text>
            <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
            <xsl:for-each select="tokenize(@target,'\s')">
            <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/text()"/>
            <xsl:text> </xsl:text>
            <xsl:text>(</xsl:text>
                    <xsl:if test="exists($root-node//tei:w[@xml:id = substring-after(current(),'#')]/parent::tei:quote)">
                        <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/parent::tei:quote/@n"/>
                    </xsl:if>
                    <xsl:if test="not(exists($root-node//tei:w[@xml:id = substring-after(current(),'#')]/parent::tei:quote))">
                        <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/parent::tei:rdg/parent::tei:app/preceding-sibling::tei:quote[1]/@n"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/parent::tei:rdg/preceding-sibling::tei:lem/text()"/>
                        <xsl:text> v.l.</xsl:text>
                    </xsl:if>
                    <xsl:text>)</xsl:text>
             <xsl:text>\par </xsl:text>
        </xsl:for-each>
        <xsl:text>\par </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:choice[parent::tei:add]">
        <xsl:if test="exists(tei:abbr/tei:hi[@rend = 'overline'])">
            <xsl:text>\cancel{</xsl:text>
                <xsl:value-of select="tei:abbr/tei:hi/text()"/>
            <xsl:text>}</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(tei:abbr/tei:hi[@rend = 'overline']))">
            <xsl:value-of select="tei:abbr/text()"/>
        </xsl:if>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="tei:expan/text()"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:add and (@place = 'above')]">
        <xsl:text>⸌</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="exists(@hand)">
            <xsl:text> - </xsl:text>
            <xsl:text>Hand: </xsl:text>
                <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                    <xsl:text>main scribe</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@hand,'#') = 'sec'">
                    <xsl:text>secondary scribe</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
                    <xsl:text>first glossator</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
                    <xsl:text>second glossator</xsl:text>
                </xsl:if>
        </xsl:if>
        <xsl:if test="exists(@xml:id)">
            <xsl:text> (</xsl:text>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'typewriter'"/>
                <xsl:value-of select="@xml:id"/>
            </xsl:element>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>⸍</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:add and (@place = 'inline')]">
        <xsl:text>|</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="exists(@hand)">
            <xsl:text> - </xsl:text>
            <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                 <xsl:text>main scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'sec'">
                <xsl:text>secondary scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-1'">
                <xsl:text>first glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:text>second glossator</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:if test="exists(@xml:id)">
            <xsl:text> (</xsl:text>
            <xsl:text>\texttt{</xsl:text>
                <xsl:value-of select="@xml:id"/>
            <xsl:text>}</xsl:text>
            <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:quote[(@type = 'biblical-quotation') and exists(parent::tei:add)]">
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>\textit{</xsl:text>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>)</xsl:text>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:foreign[@xml:lang = 'goh']">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:foreign[@xml:lang = 'grc']">
        <xsl:text>begin{greek}{</xsl:text>
            <xsl:apply-templates select="child::node()"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:text>\texttt{</xsl:text>
        <xsl:value-of select="@target"/>
        <xsl:text>}</xsl:text>
    </xsl:template>
    
</xsl:stylesheet>