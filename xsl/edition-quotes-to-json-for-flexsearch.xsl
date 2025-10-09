<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output encoding="UTF-8" media-type="text/plain" omit-xml-declaration="yes" method="text"/>
    
    <xsl:template match="/">
        <xsl:text>{"quotes" : [</xsl:text>
        <xsl:for-each select="descendant::tei:quote">
            <xsl:apply-templates select=".">
                <xsl:with-param name="number-of-quote" select="position()"/>
            </xsl:apply-templates>
            <xsl:if test="position() != last()">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>]}</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <xsl:param name="number-of-quote"/>
        <xsl:text>{</xsl:text>
        <xsl:text>"id" : "</xsl:text>
        <xsl:value-of select="$number-of-quote"/>
        <xsl:text>","id_of_quote" : "</xsl:text>
        <xsl:value-of select="concat('quote-',replace(lower-case(parent::tei:div[@type = 'page-of-Hertz-edition']/@n),' ','-'),'-',replace(replace(@n,' ','-'),',','-'))"/>
        <xsl:text>", "quote_normalized" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-normalized"/>
        <xsl:text>", "quote_critical" : "</xsl:text>
        <xsl:apply-templates select="child::node()" mode="quote-critical"/>
        <xsl:text>", "link" : "edition.html#</xsl:text>
        <xsl:value-of select="concat('quote-',replace(lower-case(parent::tei:div[@type = 'page-of-Hertz-edition']/@n),' ','-'),'-',replace(replace(@n,' ','-'),',','-'))"/>
        <xsl:text>"</xsl:text>
        <xsl:text>}</xsl:text>
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
    
</xsl:stylesheet>