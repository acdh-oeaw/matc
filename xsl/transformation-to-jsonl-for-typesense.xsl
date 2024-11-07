<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:priscian-glosses="http://achd.oeaw.ac.at/functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/json" omit-xml-declaration="yes" method="text"/>
    
    <xsl:function name="priscian-glosses:getCorrespondingAppElements" as="element(tei:app)*">
        <xsl:param name="quote" as="element(tei:quote)"/>
        <xsl:sequence select="priscian-glosses:getNextAppElement($quote)"/>
    </xsl:function>
    
    <xsl:function name="priscian-glosses:getNextAppElement">
        <xsl:param name="element" as="node()"/>
        <xsl:if test="local-name($element/following-sibling::*[1]) = 'app'">
            <xsl:sequence>
                <xsl:copy-of select="$element/following-sibling::*[1] | priscian-glosses:getNextAppElement($element/following-sibling::*[1])"/>
            </xsl:sequence>
        </xsl:if>
        <xsl:if test="local-name($element/following-sibling::*[1]) = 'quote'"/>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:for-each select="descendant::tei:quote">
            <xsl:text>{"quote" : </xsl:text>
            <xsl:apply-templates select="."/>
            <xsl:text>}
</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:text>{</xsl:text>
        <xsl:text>"quotation" : "</xsl:text>
        <xsl:value-of select="concat(parent::div[@type = 'page-of-Hertz-edition']/@n,' ',@n)"/>
        <xsl:text>", "quote_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
        <xsl:text>", "quote_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
        <xsl:text>", "interventions" : [</xsl:text>
        <xsl:for-each select="priscian-glosses:getCorrespondingAppElements(self::node())">
            <xsl:apply-templates select="."/>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="quote-normalized"/>    
    
    <xsl:template match="tei:gap" mode="quote-normalized">
        <xsl:value-of select="'...'"/>
    </xsl:template>
    
    <xsl:template match="tei:supplied" mode="quote-normalized">
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="quote-normalized">
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="quote-normalized">
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:hi" mode="quote-normalized">
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:foreign" mode="quote-normalized">
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
    </xsl:template>
    
    <xsl:template match="tei:pb" mode="quote-normalized"/>
    
    <xsl:template match="tei:g" mode="quote-normalized">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="quote-normalized">
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
    
    <xsl:template match="tei:lb" mode="quote-critical">
        <xsl:if test="not(exists(@break))">
            <xsl:value-of select="' '"/>
        </xsl:if>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="concat(@ed,',',@n)"/>
        <xsl:text>)</xsl:text>
        <xsl:if test="not(exists(@break))">
            <xsl:value-of select="' '"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:gap" mode="quote-critical">
        <xsl:value-of select="for $i in (1 to @quantity) return '.'"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@reason"/>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:supplied" mode="quote-critical">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
        <xsl:text>/</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="quote-critical">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:quote]" mode="quote-critical">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
        <xsl:text> (</xsl:text>
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
        <xsl:if test="exists(@place)">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="@place"/>
        </xsl:if>
        <xsl:if test="exists(child::tei:hi) and exists(child::tei:hi/@rend)">
            <xsl:text> - </xsl:text>
            <xsl:value-of select="child::tei:hi/@rend"/>
        </xsl:if>
        <xsl:text>)/</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:hi[parent::tei:add[parent::tei:quote]]" mode="quote-critical">
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:pb" mode="quote-critical"/>
    
    <xsl:template match="tei:foreign" mode="quote-critical">
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="quote-critical">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="quote-critical">
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
    
    <xsl:template match="tei:app[@type = 'rubrication']">
        <xsl:text>{"type_of_intervention" : "rubrication",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"lemma" : {</xsl:text>
        <xsl:apply-templates select="child::tei:lem"/>
        <xsl:text>},</xsl:text>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="rubrication-reading"/>
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'reference-signs']">
        <xsl:text>{"type_of_intervention" : "reference-sign",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
        <xsl:text>"lemma" : {</xsl:text>
        <xsl:apply-templates select="child::tei:lem"/>
        <xsl:text>},</xsl:text>
        <xsl:text>"reading" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="reference-signs-reading"/>
        <xsl:text>}}</xsl:text>
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
        <xsl:text>"analysis" : [], </xsl:text>
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
        <xsl:variable name="root-node" select="root()"/>
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
        <xsl:for-each select="tokenize(child::tei:add/@ana,'\s+')">
            <xsl:variable name="reference" select="substring-after(.,'#')"/>
            <xsl:text>{</xsl:text>
            <xsl:text>"analysis_category_id" : "</xsl:text>
            <xsl:value-of select="$root-node/descendant::tei:category[@xml:id = $reference]/@n"/>
            <xsl:text>", "analysis_category" : "</xsl:text>
            <xsl:value-of select="normalize-space($root-node/descendant::tei:category[@xml:id = $reference]/child::tei:catDesc/text())"/>
            <xsl:text>"}</xsl:text>
            <xsl:if test="position() != last()">
                <xsl:value-of select="','"/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>],</xsl:text>
        <xsl:text>"reading_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::tei:add" mode="reference-signs-reading-normalized"/>
        <xsl:text>", "reading_critical" : "</xsl:text>
        <xsl:apply-templates select="child::tei:add" mode="reference-signs-reading-critical"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="reference-signs-reading-normalized">
        <xsl:apply-templates select="tei:g"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="reference-signs-reading-critical">
        <xsl:apply-templates select="tei:g"/>
    </xsl:template>
    
    <xsl:template match="tei:g[parent::tei:add[parent::tei:rdg]]">
        <xsl:variable name="glyph-reference" select="substring-after(@ref,'#')"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = $glyph-reference]/tei:localProp[@name = 'Name']/@value"/>
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