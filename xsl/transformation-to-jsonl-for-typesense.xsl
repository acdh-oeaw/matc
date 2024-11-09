<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:priscian-glosses="http://achd.oeaw.ac.at/functions"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text/plain" omit-xml-declaration="yes" method="text"/>
    
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
    
    <xsl:variable name="main-root" select="/"/>
    
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
        <xsl:if test="local-name(following-sibling::*[1]) = 'app'">
            <xsl:for-each select="priscian-glosses:getCorrespondingAppElements(self::node())">
                <xsl:apply-templates select="."/>
                <xsl:if test="position() != last()">
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="local-name(following-sibling::*[1]) = 'quote'">
            <xsl:text>{"type_of_intervention" : "", "id_of_intervention" : "", "lemma" : {"witness" : "", "text_of_lemma" : ""}, "reading" : {"witness" : "", "hand" : "", "place" : "", "analysis" : [{"analysis_category_id" : "", "analysis_category": ""}],"reading_normalized": "", "reading_critical" : ""}}</xsl:text>
        </xsl:if>
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
        <xsl:text>〈</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="quote-critical">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:quote]" mode="quote-critical">
        <xsl:text>〈</xsl:text>
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
        <xsl:text>)〉</xsl:text>
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
        <xsl:text>{"type_of_intervention" : "reference sign",</xsl:text>
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
    
    <xsl:template match="tei:app[@type = 'text-variation']">
        <xsl:text>{"type_of_intervention" : "text variation",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
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
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'gloss']">
        <xsl:text>{"type_of_intervention" : "gloss",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
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
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'emendation']">
        <xsl:text>{"type_of_intervention" : "emendation",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
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
        <xsl:text>}}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'annotation-signs']">
        <xsl:text>{"type_of_intervention" : "annotation sign",</xsl:text>
        <xsl:text>"id_of_intervention" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>",</xsl:text>
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