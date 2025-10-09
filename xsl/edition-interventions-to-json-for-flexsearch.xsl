<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text/plain" omit-xml-declaration="yes" method="text"/>
    
    <xsl:variable name="main-root" select="/"/>
    
    <xsl:template match="/">
        <xsl:text>{"interventions" : [</xsl:text>
        <xsl:for-each select="descendant::tei:app">
            <xsl:apply-templates select=".">
                <xsl:with-param name="number-for-id" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'rubrication']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "rubrication",</xsl:text>
        <xsl:text>"lemma" : {</xsl:text>
        <xsl:apply-templates select="child::tei:lem"/>
        <xsl:text>},</xsl:text>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="rubrication-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'reference-signs']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "reference sign",</xsl:text>
        <xsl:text>"lemma" : {</xsl:text>
        <xsl:apply-templates select="child::tei:lem"/>
        <xsl:text>},</xsl:text>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="reference-signs-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'text-variation']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "text variation",</xsl:text>
        <xsl:if test="exists(child::tei:lem)">
            <xsl:text>"lemma" : {</xsl:text>
            <xsl:apply-templates select="child::tei:lem"/>
            <xsl:text>},</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(child::tei:lem))">
            <xsl:text>"lemma" : {"witness" : "","text_of_lemma": ""},</xsl:text>
        </xsl:if>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="text-variation-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'gloss']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "gloss",</xsl:text>
        <xsl:if test="exists(child::tei:lem)">
            <xsl:text>"lemma" : {</xsl:text>
            <xsl:apply-templates select="child::tei:lem"/>
            <xsl:text>},</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(child::tei:lem))">
            <xsl:text>"lemma" : {"witness" : "","text_of_lemma": ""},</xsl:text>
        </xsl:if>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="gloss-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'emendation']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "emendation",</xsl:text>
        <xsl:if test="exists(child::tei:lem)">
            <xsl:text>"lemma" : {</xsl:text>
            <xsl:apply-templates select="child::tei:lem"/>
            <xsl:text>},</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(child::tei:lem))">
            <xsl:text>"lemma" : {"witness" : "","text_of_lemma": ""},</xsl:text>
        </xsl:if>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="emendation-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'annotation-signs']">
        <xsl:param name="number-for-id"/>
        <xsl:text>{"id" : "</xsl:text>
        <xsl:value-of select="$number-for-id"/>
        <xsl:text>","id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"type_of_intervention" : "annotation sign",</xsl:text>
        <xsl:if test="exists(child::tei:lem)">
            <xsl:text>"lemma" : {</xsl:text>
            <xsl:apply-templates select="child::tei:lem"/>
            <xsl:text>},</xsl:text>
        </xsl:if>
        <xsl:if test="not(exists(child::tei:lem))">
            <xsl:text>"lemma" : {"witness" : "","text_of_lemma": ""},</xsl:text>
        </xsl:if>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="annotation-signs-reading"/>
        <xsl:text>},"link" : "edition.html#</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>"}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lem">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>","text_of_lemma" : "</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="annotation-signs-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "place" : "</xsl:text>
        <xsl:value-of select="child::tei:add[1]/@place"/>
        <xsl:text>", "analysis" : [</xsl:text>
        <xsl:if test="contains(normalize-space(child::tei:add[1]/@ana),' ')">
            <xsl:for-each select="tokenize(child::tei:add[1]/@ana,'\s+')">
                <xsl:variable name="reference" select="substring-after(.,'#')"/>
                <xsl:text>{</xsl:text>
                <xsl:text>"analysis_category_id" : "</xsl:text>
                <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
                <xsl:text>", "analysis_category" : "</xsl:text>
                <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="','"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="not(contains(normalize-space(child::tei:add[1]/@ana),' '))">
            <xsl:variable name="reference" select="substring-after(child::tei:add[1]/@ana,'#')"/>
            <xsl:text>{</xsl:text>
            <xsl:text>"analysis_category_id" : "</xsl:text>
            <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
            <xsl:text>", "analysis_category" : "</xsl:text>
            <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
            <xsl:text>"}</xsl:text>
        </xsl:if>
        <xsl:text>], "reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="annotation-signs-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="annotation-signs-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="annotation-signs-reading-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="annotation-signs-reading-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="emendation-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "place" : "",</xsl:text>
        <xsl:text>"analysis" : [{"analysis_category_id" : "", "analysis_category" : ""}],</xsl:text>
        <xsl:text>"reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="emendation-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="emendation-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="emendation-reading-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="emendation-reading-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="emendation-reading-normalized"/>
    
    <xsl:template match="tei:del" mode="emendation-reading-critical">
        <xsl:text>〈〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="emendation-reading-critical"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@type"/>
        <xsl:text>〉〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="emendation-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="emendation-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="emendation-reading-critical">
        <xsl:text>〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="emendation-reading-critical"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:if test="exists(@type)">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@type"/>
        </xsl:if>
        <xsl:if test="exists(@hand)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="substring-after(@hand,'#') = 'scr'">
                    <xsl:value-of select="'main writer'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:value-of select="'Otfrid'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                    <xsl:value-of select="'second glossator'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'sec'">
                    <xsl:value-of select="'other secondary writer'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="emendation-reading-critical">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="text()" mode="emendation-reading-normalized">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="gloss-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add[1]/@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "place" : "</xsl:text>
        <xsl:value-of select="child::tei:add[1]/@place"/>
        <xsl:text>", "analysis" : [</xsl:text>
        <xsl:if test="contains(normalize-space(child::tei:add[1]/@ana),' ')">
            <xsl:for-each select="tokenize(child::tei:add[1]/@ana,'\s+')">
                <xsl:variable name="reference" select="substring-after(.,'#')"/>
                <xsl:text>{</xsl:text>
                <xsl:text>"analysis_category_id" : "</xsl:text>
                <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
                <xsl:text>", "analysis_category" : "</xsl:text>
                <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="','"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="not(contains(normalize-space(child::tei:add[1]/@ana),' '))">
            <xsl:variable name="reference" select="substring-after(child::tei:add[1]/@ana,'#')"/>
            <xsl:text>{</xsl:text>
            <xsl:text>"analysis_category_id" : "</xsl:text>
            <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
            <xsl:text>", "analysis_category" : "</xsl:text>
            <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
            <xsl:text>"}</xsl:text>
        </xsl:if>
        <xsl:text>], "reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="gloss-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="text-variation-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", </xsl:text>
        <xsl:text>"place" : "", </xsl:text>
        <xsl:text>"analysis" : [{"analysis_category_id" : "", "analysis_category" : ""}], </xsl:text>
        <xsl:text>"reading_normalized" : "</xsl:text>
        <xsl:if test="not(exists(child::node()))">
            <xsl:text>omitted</xsl:text>
        </xsl:if>
        <xsl:if test="exists(child::node())">
            <xsl:apply-templates select="child::node()" mode="text-variation-reading-normalized"/>
        </xsl:if>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:if test="not(exists(child::node()))">
            <xsl:text>omitted</xsl:text>
        </xsl:if>
        <xsl:if test="exists(child::node())">
            <xsl:apply-templates select="child::node()" mode="text-variation-reading-critical"/>
        </xsl:if>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:ptr" mode="gloss-reading-normalized"/>
    
    <xsl:template match="tei:ptr" mode="gloss-reading-critical"/>
    
    <xsl:template match="tei:g" mode="gloss-reading-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="gloss-reading-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap" mode="gloss-reading-normalized">
        <xsl:value-of select="'...'"/>
    </xsl:template>
    
    <xsl:template match="tei:gap" mode="gloss-reading-critical">
        <xsl:value-of select="for $i in (1 to @quantity) return '.'"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@reason"/>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:choice" mode="gloss-reading-normalized">
        <xsl:value-of select="child::tei:expan/text()"/>
    </xsl:template>
    
    <xsl:template match="tei:choice" mode="gloss-reading-critical">
        <xsl:apply-templates select="child::tei:abbr" mode="gloss-reading-critical"/>
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="child::tei:expan" mode="gloss-reading-critical"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:abbr" mode="gloss-reading-critical">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:hi" mode="gloss-reading-critical">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:expan" mode="gloss-reading-critical">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:add]" mode="gloss-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:add]" mode="gloss-reading-critical">
        <xsl:text>〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
        <xsl:text> - </xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:foreign" mode="gloss-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:foreign" mode="gloss-reading-critical">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="gloss-reading-normalized"/>
    
    <xsl:template match="tei:del" mode="gloss-reading-critical">
        <xsl:text>〈〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
        <xsl:text> - deleted〉〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="gloss-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="gloss-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="gloss-reading-critical">
        <xsl:text>〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="gloss-reading-critical"/>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="gloss-reading-critical">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="gloss-reading-normalized">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="text-variation-reading-normalized">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="text-variation-reading-critical">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="text-variation-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="text-variation-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="text-variation-reading-normalized">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    <xsl:template match="tei:lb" mode="text-variation-reading-critical">
        <xsl:text>(</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="text-variation-reading-critical">
        <xsl:text>〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="text-variation-reading-critical"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:if test="exists(@hand)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="substring-after(@hand,'#') = 'scr'">
                    <xsl:value-of select="'main writer'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:value-of select="'Otfrid'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                    <xsl:value-of select="'second glossator'"/>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'sec'">
                    <xsl:value-of select="'other secondary writer'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="exists(@type)">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@type"/>
        </xsl:if>
        <xsl:text>)〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="text-variation-reading-critical">
        <xsl:text>〈〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="text-variation-reading-critical"/>
        <xsl:text> - deleted〉〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="text-variation-reading-normalized"/>
    
    <xsl:template match="tei:g" mode="text-variation-reading-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="text-variation-reading-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="text-variation-reading-normalized">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="text-variation-reading-critical">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="rubrication-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", </xsl:text>
        <xsl:text>"place" : "", </xsl:text>
        <xsl:text>"analysis" : [{"analysis_category_id" : "", "analysis_category" : ""}], </xsl:text>
        <xsl:text>"reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="rubrication-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="rubrication-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:hi" mode="rubrication-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="rubrication-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:hi" mode="rubrication-reading-critical">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="child::node()" mode="rubrication-reading-critical"/>
        <xsl:text> - </xsl:text>
        <xsl:value-of select="@rend"/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="reference-signs-reading">
        <xsl:text>"witness" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(@wit,'#') = 'EDITION'">
                <xsl:value-of select="'Edition of Hertz'"/>
            </xsl:when>
            <xsl:when test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:value-of select="'Codex 50 Weiss.'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "hand" : "</xsl:text>
        <xsl:choose>
            <xsl:when test="substring-after(child::tei:add/@hand,'#') = 'scr'">
                <xsl:value-of select="'main writer'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add/@hand,'#') = 'Otfrid'">
                <xsl:value-of select="'Otfrid'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add/@hand,'#') = 'gl-2'">
                <xsl:value-of select="'second glossator'"/>
            </xsl:when>
            <xsl:when test="substring-after(child::tei:add/@hand,'#') = 'sec'">
                <xsl:value-of select="'other secondary writer'"/>
            </xsl:when>
        </xsl:choose>
        <xsl:text>", "place" : "</xsl:text>
        <xsl:value-of select="child::tei:add/@place"/>
        <xsl:text>", </xsl:text>
        <xsl:text>"analysis" : [</xsl:text>
        <xsl:if test="contains(normalize-space(child::tei:add/@ana),' ')">
            <xsl:for-each select="tokenize(child::tei:add/@ana,'\s+')">
                <xsl:variable name="reference" select="substring-after(.,'#')"/>
                <xsl:text>{</xsl:text>
                <xsl:text>"analysis_category_id" : "</xsl:text>
                <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
                <xsl:text>", "analysis_category" : "</xsl:text>
                <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
                <xsl:text>"}</xsl:text>
                <xsl:if test="position() != last()">
                    <xsl:value-of select="','"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="not(contains(normalize-space(child::tei:add/@ana),' '))">
            <xsl:variable name="reference" select="substring-after(child::tei:add/@ana,'#')"/>
            <xsl:text>{</xsl:text>
            <xsl:text>"analysis_category_id" : "</xsl:text>
            <xsl:value-of select="$main-root/descendant::tei:category[@xml:id = $reference]/@n"/>
            <xsl:text>", "analysis_category" : "</xsl:text>
            <xsl:value-of select="normalize-space($main-root/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
            <xsl:text>"}</xsl:text>
        </xsl:if>
        <xsl:text>],</xsl:text>
        <xsl:text>"reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::tei:add" mode="reference-signs-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::tei:add" mode="reference-signs-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="reference-signs-reading-normalized">
        <xsl:apply-templates select="child::node()" mode="reference-signs-reading-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="reference-signs-reading-critical">
        <xsl:apply-templates select="child::node()" mode="reference-signs-reading-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="reference-signs-reading-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root/descendant::tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="reference-signs-reading-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$main-root/descendant::tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:foreign">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="rubrication-reading-normalized">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()" mode="rubrication-reading-critical">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:choose>
            <xsl:when test=". = ' '">
                <xsl:value-of select="' '"/>
            </xsl:when>
            <xsl:when test="starts-with(.,' ')">
                <xsl:choose>
                    <xsl:when test="ends-with(.,' ')">
                        <xsl:value-of select="concat(' ',normalize-space(.),' ')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(' ',normalize-space(.))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="ends-with(.,' ') and not(starts-with(.,' '))">
                <xsl:value-of select="concat(normalize-space(.),' ')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(.)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>