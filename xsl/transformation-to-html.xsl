<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/xhtml" method="xhtml"/>
    
    <xsl:template match="/">
        <html>
            <xsl:apply-templates select="child::node()"/>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <head>
            <link rel="stylesheet" href="./css/formats.css"/>
        </head>
        <body class="body-formats">
            <div class="heading-1">Priscianus: Institutiones (Cod. Guelf. 50 Weiss.)</div>
            <xsl:apply-templates select="child::node()"/>
        </body>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc"/>
        <xsl:apply-templates select="tei:encodingDesc/tei:editorialDecl"/>
        <xsl:apply-templates select="tei:encodingDesc/tei:charDecl"/>
    </xsl:template>
    
    <xsl:template match="tei:sourceDesc">
        <div class="list-of-witnesses">
            <p class="heading-2">List of witnesses:</p>
            <xsl:apply-templates select="tei:listWit/tei:witness"/>
        </div>
        <div class="list-of-hands">
            <p class="heading-2">List of hands:</p>
            <xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:witness">
        <div class="main-text">
            <span class="xml-id">
                <xsl:value-of select="@xml:id"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="bibliography-title">
                <xsl:value-of select="tei:bibl/text()"/>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:handNote">
        <div class="main-text">
            <span class="hand-id">
                <xsl:value-of select="@xml:id"/>
            </span>
            <xsl:text> </xsl:text>
            <span class="hand-note">
                <xsl:value-of select="text()"/>
            </span>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:editorialDecl">
        <div class="editorial-declaration">
            <p class="heading-2">Editorial prinicples:</p>
            <ul>
                <xsl:apply-templates select="tei:normalization/tei:p"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:p[parent::tei:normalization]">
        <li>
            <xsl:value-of select="text()"/>
        </li>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'abbreviations']">
        <div class="pictures">
            <p class="heading-2">Signs for abbreviations:</p>
            <ul>
                <xsl:apply-templates select="tei:glyph"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'construe-marks']">
        <div class="pictures">
            <p class="heading-2">Signs for construe marks:</p>
            <ul>
                <xsl:apply-templates select="tei:glyph"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'reference signs']">
        <div class="pictures">
            <p class="heading-2">Reference signs:</p>
            <ul>
                <xsl:apply-templates select="tei:glyph"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:glyph">
        <li>
            <xsl:element name="img">
               <xsl:attribute name="src" select="concat('data',substring-after(tei:figure/tei:graphic/@url,'..'))"/>
            </xsl:element>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="tei:localProp[@name = 'Name']/@value"/>
        </li>
    </xsl:template>
    
    <xsl:template match="tei:text/tei:body/tei:div/tei:div[@type = 'page-of-Keil-edition']">
        <div class="page-of-edition">
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat(substring-before(root()//tei:prefixDef[@ident = 'images-keil']/@replacementPattern,'$1'),substring-after(current()/@corresp,'images-keil:'))"/>
                </xsl:attribute>
                <xsl:attribute name="target">
                    <xsl:value-of select="'_blank'"/>
                </xsl:attribute>
                <xsl:text>Picture of edition</xsl:text>
            </xsl:element>
            <p class="main-text-paragraph">
                <xsl:value-of select="@n"/>
                <xsl:if test="exists(@prev)">
                    <xsl:text> (continued)</xsl:text>
                </xsl:if>
            </p>
            <div class="quotation-of-edition-with-app">
                <xsl:apply-templates select="child::node()"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <p class="main-text-paragraph">
            <xsl:value-of select="@n"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="child::node()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="text()[parent::tei:quote]">
        <span class="bold-text">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb[parent::tei:quote]">
        <span class="italic-text">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>) </xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:text>[</xsl:text>
            <xsl:value-of select="@quantity"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@unit"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="@reason"/>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:quote]">
        <span class="bold-text">
            <xsl:text> [</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:quote]">
        <span class="bold-text">
            <xsl:value-of select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:quote]">
        <span class="bold-italic-text">
            <xsl:apply-templates/>
        </span>
        <span class="italic-text">
            <xsl:text>(</xsl:text>
            <xsl:value-of select="substring-after(@hand,'#')"/>
            <xsl:text>)</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <p class="main-text-paragraph">
            <span class="bold-text">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>)</xsl:text>
            </span>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:app">
        <div class="apparatus">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:lem">
        <p class="apparatus-lemma">
            <xsl:value-of select="substring-after(@wit,'#')"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="text()"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <div class="apparatus-reading">
            <xsl:value-of select="substring-after(@wit,'#')"/>
            <xsl:text>: </xsl:text>
            <xsl:if test="not(exists(text())) and not(exists(child::node()))">
                <xsl:text>-</xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg]">
        <xsl:apply-templates/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@place"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring-after(@hand,'#')"/>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g">
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>|</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:rdg]">
        <xsl:value-of select="text()"/>
    </xsl:template>
    
    <xsl:template match="tei:note">
        <div class="note">
            <xsl:apply-templates/>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@place"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="substring-after(@hand,'#')"/>
            <xsl:text>) </xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <p class="pointer">
            <xsl:value-of select="parent::tei:rdg/parent::tei:app/tei:lem/text()"/>
            <xsl:text> &#8594; </xsl:text>
            <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
            <xsl:for-each select="tokenize(@target,'\s')">
                <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/text()"/>
                <xsl:text> </xsl:text>
            </xsl:for-each>
        </p>
    </xsl:template>
    
</xsl:stylesheet>