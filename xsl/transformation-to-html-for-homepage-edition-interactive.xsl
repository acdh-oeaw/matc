<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0"/>
    
    <xsl:template match="/">
        <html lang="en">
            <xsl:apply-templates select="child::node()"/>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:TEI">
        <xsl:result-document encoding="UTF-8" href="json/glosses.json" media-type="text/plain" omit-xml-declaration="true" method="text">
            <xsl:text>{ "glosses" : [</xsl:text>
                <xsl:apply-templates select="//tei:app[@type = 'gloss']" mode="glosses-as-json"/>
            <xsl:text>]}</xsl:text>
        </xsl:result-document>
        <xsl:result-document encoding="UTF-8" href="json/annotation-signs.json" media-type="text/plain" omit-xml-declaration="true" method="text">
            <xsl:text>{ "annotation-signs" : [</xsl:text>
                <xsl:apply-templates select="//tei:app[@type = 'annotation-signs']" mode="annotation-signs-as-json"/>
            <xsl:text>]}</xsl:text>
        </xsl:result-document>
        <xsl:result-document encoding="UTF-8" href="json/text-variations.json" media-type="text/plain" omit-xml-declaration="true" method="text">
            <xsl:text>{ "text-variations" : [</xsl:text>
            <xsl:apply-templates select="//tei:app[(@type = 'text-variation') and exists(child::tei:rdg/child::tei:add/@facs)]" mode="text-variations-as-json"/>
            <xsl:text>]}</xsl:text>
        </xsl:result-document>
        <xsl:result-document encoding="UTF-8" href="json/reference-signs.json" media-type="text/plain" omit-xml-declaration="true" method="text">
            <xsl:text>{ "reference-signs" : [</xsl:text>
            <xsl:apply-templates select="//tei:app[(@type = 'reference-signs') and exists(child::tei:rdg/child::tei:add/@facs)]" mode="reference-signs-as-json"/>
            <xsl:text>]}</xsl:text>
        </xsl:result-document>
        <xsl:result-document encoding="UTF-8" href="json/notes.json" media-type="text/plain" omit-xml-declaration="true" method="text">
            <xsl:text>{ "notes" : [</xsl:text>
            <xsl:apply-templates select="//tei:note[exists(@facs)]" mode="notes-as-json"/>
            <xsl:text>]}</xsl:text>
        </xsl:result-document>
        <head>
            <meta charset="UTF-8"/>
            <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
            <meta name="mobile-web-app-capable" content="yes"/>
            <meta name="apple-mobile-web-app-capable" content="yes"/>
            <meta name="apple-mobile-web-app-title" content="The Wissembourg Priscian Glosses"/>
            <link rel="profile" href="http://gmpg.org/xfn/11"/>
            <title>The Wissembourg Priscian Glosses</title>
            <link rel="stylesheet" id="fundament-styles"  href="./css/fundament.min.css" type="text/css"/>
            <link rel="stylesheet" id="fundament-custom-styles" href="./css/custom.css" type="text/css"/>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer"></link>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Noto Serif"></link>
            <link rel="shortcut icon" type="image/x-icon" href="./images/favicon.png"/>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/3.1.0/openseadragon.min.js" integrity="sha512-uZWCk71Y8d7X/dnBNU9sISZQv78vDTglLF8Uaga0AimD7xmjJhFoa67VIcIySAoTHqxIt/0ly9l5ft9MUkynQA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        </head>
        <body class="page">
            <div class="hfeed site" id="page">
                <!-- ******************* The Navbar Area ******************* -->
                <div class="wrapper-fluid wrapper-navbar sticky-navbar" id="wrapper-navbar" itemscope="itemscope" itemtype="http://schema.org/WebSite">
                    <a class="skip-link screen-reader-text sr-only" href="#content">Skip to content</a>
                    <nav class="navbar navbar-expand-lg navbar-light">
                        <div class="container" id="banner">
                            <!-- Your site title as branding in the menu -->
                            <a href="https://www.oeaw.ac.at/imafo/forschung/historische-identitaetsforschung/projekte/margins-at-the-centre" class="navbar-brand custom-logo-link" rel="home" itemprop="url"><img src="./images/logo-margins.jpg" class="img-fluid" alt="Margins at the centre logo" itemprop="logo" /></a><!-- end custom logo -->
                            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon"></span>
                            </button>
                            <div class="collapse navbar-collapse justify-content-end" id="navbarNavDropdown">
                                <!-- Your menu goes here -->
                                <ul id="main-menu" class="navbar-nav">
                                    <li class="nav-item active"><a title="Home" href="./index.html" class="nav-link">Home</a></li>
                                    <li class="nav-item dropdown">
                                        <a title="The Project" href="./about.html" data-toggle="dropdown" class="nav-link dropdown-toggle">The Project <span class="caret"></span></a>
                                        <ul class=" dropdown-menu" role="menu">
                                            <li class="nav-item dropdown-submenu">
                                                <a title="About" href="./about.html" class="nav-link">About</a>
                                            </li>
                                            <li class="nav-item dropdown-submenu">
                                                <a title="Team" href="./team.html" class="nav-link">Team</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="nav-item dropdown">
                                        <a title="Digital Edition" href="./introduction.html" data-toggle="dropdown" class="nav-link dropdown-toggle">Digital Edition <span class="caret"></span></a>
                                        <ul class=" dropdown-menu" role="menu">
                                            <li class="nav-item dropdown-submenu">
                                                <a title="Introduction" href="./introduction.html" class="nav-link">Introduction</a>
                                            </li>
                                            <li class="nav-item dropdown-submenu">
                                                <a title="Edition" href="./edition.html" class="nav-link">Edition</a>
                                            </li>
                                            <li class="nav-item dropdown-submenu"><a title="Interactive Edition" href="./edition-interactive.html" class="nav-link">Interactive Edition</a></li>
                                            <li class="nav-item dropdown-submenu"><a title="Simplified Edition" href="./edition-simplified.html" class="nav-link">Simplified Edition</a></li>
                                            <li class="nav-item dropdown-submenu"><a title="Statistics" href="./statistics.html" class="nav-link">Statistics</a></li>
                                            <li class="nav-item dropdown-submenu">
                                                <a title="Technical Documentation" href="./technical-documentation.html" class="nav-link">Technical Documentation</a>
                                            </li>
                                        </ul>
                                    </li>
                                    <li class="nav-item">
                                        <a title="Old High German Glosses" href="./old-high-german-glosses.html" class="nav-link">Old High German Glosses</a>
                                    </li>
                                    <li class="nav-item">
                                        <a title="Output &amp; Events" href="./output-and-events.html" class="nav-link">Output &amp; Events</a>
                                    </li>
                                    <li class="nav-item">
                                        <a title="Contact" href="./contact.html" class="nav-link">Contact</a>
                                    </li>
                                </ul>
                            </div>
                            <!-- .collapse navbar-collapse -->
                        </div>
                        <!-- .container -->
                    </nav>
                    <!-- .site-navigation -->
                </div>
                <!-- .wrapper-navbar end -->
                
                <div class="wrapper" id="single-wrapper">
                    <div class="container-fluid" id="content" tabindex="-1">
                        <div class="row">
                            <div class="col-md-12 content-area" id="primary">
                                <main class="site-main" id="main">
                                    <article>
                                        <header class="entry-header background-color-brown">
                                            <h1 class="heading-level-1">The Wissembourg Priscian Glosses</h1>
                                            <h2 class="heading-level-2">Interactive Digital Edition</h2>
                                        </header><!-- .entry-header -->
                                        <div class="row">
                                            <div class="col-md-8">
                                                <div class="entry-content">
                                                    <xsl:element name="p">
                                                        <xsl:attribute name="class" select="'heading-2'"/>
                                                        <xsl:value-of select="'Table of Contents'"/>
                                                    </xsl:element>
                                                    <xsl:apply-templates select="descendant::tei:div[@type = 'page-of-Hertz-edition'][not(exists(@prev))]" mode="table-of-contents"/>
                                                    <xsl:apply-templates select="child::node()"/>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div style=" position: fixed; bottom: 0;">
                                                    <div id="openseadragon" style="width: 600px; height: 800px;"></div>
                                                </div>
                                            </div>
                                        </div>
                                    </article>
                                </main>
                            </div>
                            <button onclick="goToTop()" id="go-to-top-button" title="Go to top">Go to top</button>
                        </div>
                    </div>
                </div>
            <div class="wrapper fundament-default-footer" id="wrapper-footer-full">
                <div class="container" id="footer-full-content" tabindex="-1">
                    <div class="footer-separator">
                        <i data-feather="message-circle"></i> CONTACT
                    </div>
                    <div class="row">
                        <div class="footer-widget col-lg-1 col-md-2 col-sm-2 col-xs-6 col-3">
                            <div class="textwidget custom-html-widget">
                                <a href="/"><img src="https://fundament.acdh.oeaw.ac.at/common-assets/images/acdh_logo.svg" class="image" alt="ACDH Logo" style="max-width: 100%; height: auto;" title="ACDH Logo"></img></a>
                            </div>
                        </div>
                        <!-- .footer-widget -->
                        <div class="footer-widget col-lg-4 col-md-4 col-sm-6 col-9">
                            <div class="textwidget custom-html-widget">
                                <p>
                                    ACDH-CH
                                    <br/>
                                        Austrian Centre for Digital Humanities <br/> and Cultural Heritage
                                        <br/>
                                            Austrian Academy of Sciences
                                </p>
                                <p>
                                    Sonnenfelsgasse 19,
                                    <br/>
                                        1010 Vienna
                                </p>
                                <p>
                                    T: +43 1 51581-2200
                                    <br/>
                                        E: <a href="mailto:acdh-ch@oeaw.ac.at">acdh-ch@oeaw.ac.at</a>
                                </p>
                            </div>
                        </div>
                        <div class="footer-widget col-lg-1 col-md-2 col-sm-2 col-xs-6 col-3">
                            <div class="textwidget custom-html-widget">
                                <a href="https://www.fwf.ac.at/"><img src="./images/fwf-logo.png" class="image" alt="FWF Logo" style="max-width: 250%; height: auto;" title="FWF Logo"></img></a>
                            </div>
                        </div>
                        <!-- .footer-widget -->
                        <div class="footer-widget col-lg-3 col-md-4 col-sm-4 ml-auto">
                            <div class="textwidget custom-html-widget">
                                <h6>HELPDESK</h6>
                                <p>ACDH-CH runs a helpdesk offering advice for questions related to various digital humanities topics.</p>
                                <p>
                                    <a class="helpdesk-button" href="mailto:acdh-helpdesk@oeaw.ac.at">ASK US!</a>
                                </p>
                            </div>
                        </div>
                        <!-- .footer-widget -->
                    </div>
                </div>
            </div>
            <!-- #wrapper-footer-full -->
            <div class="footer-imprint-bar" id="wrapper-footer-secondary" style="text-align:center; padding:0.4rem 0; font-size: 0.9rem;">
                © Copyright OEAW | <a href="https://www.oeaw.ac.at/die-oeaw/impressum/">Impressum/Imprint</a>
            </div>
            </div>
            <!-- #page we need this extra closing tag here -->
            <script type="text/javascript" src="./vendor/jquery/jquery.min.js"></script>
            <script type="text/javascript" src="./js/fundament.min.js"></script>
            <script type="text/javascript" src="./js/custom.js"/>
            <script type="text/javascript" src="./js/scroll-to-top.js"></script>
        </body>
    </xsl:template>
    
    <xsl:template match="tei:div[@type = 'page-of-Hertz-edition'][not(exists(@prev))]" mode="table-of-contents">
        <xsl:element name="p">
            <xsl:attribute name="class" select="'navigation-entry'"/>
            <xsl:element name="a">
                <xsl:attribute name="href" select="concat('#',@xml:id)"/>
                <xsl:value-of select="@n"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader">
        <!-- <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc"/> -->
        <!-- <xsl:apply-templates select="tei:encodingDesc/tei:editorialDecl"/> -->
        <xsl:apply-templates select="tei:encodingDesc/tei:charDecl[(@n = 'abbreviations') or (@n = 'construe-marks') or (@n = 'reference signs') or (@n = 'attention signs')]"/>
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
            <div>
                <xsl:apply-templates select="tei:glyph"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'construe-marks']">
        <div class="pictures">
            <p class="heading-2">Signs for construe marks:</p>
            <div>
                <xsl:apply-templates select="tei:glyph"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'reference signs']">
        <div class="pictures">
            <p class="heading-2">Reference signs:</p>
            <div>
                <xsl:apply-templates select="tei:glyph"/>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'attention signs']">
        <div class="pictures">
            <p class="heading-2">Annotation signs:</p>
            <div>
                <xsl:apply-templates select="tei:glyph"/>
            </div>
            <xsl:apply-templates select="following-sibling::tei:charDecl[1][@n = 'excerption signs']" mode="annotation-signs-heading"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'excerption signs']" mode="annotation-signs-heading">
        <div>
            <xsl:apply-templates select="tei:glyph"/>
        </div>
        <xsl:apply-templates select="following-sibling::tei:charDecl[1][@n = 'omission signs']" mode="annotation-signs-heading"/>
    </xsl:template>
    
    <xsl:template match="tei:charDecl[@n = 'omission signs']" mode="annotation-signs-heading">
        <div>
            <xsl:apply-templates select="tei:glyph"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:glyph">
        <p class="glyph-section">
            <xsl:element name="img">
                <xsl:attribute name="src" select="replace(tei:figure/tei:graphic/@url,'../pictures','./data/pictures')"/>
                <xsl:if test="exists(child::tei:figure/child::tei:graphic/@height) and exists(child::tei:figure/child::tei:graphic/@width)">
                    <xsl:attribute name="style">
                        <xsl:text>width: </xsl:text>
                        <xsl:value-of select="child::tei:figure/child::tei:graphic/@width"/>
                        <xsl:text>; height: </xsl:text>
                        <xsl:value-of select="child::tei:figure/child::tei:graphic/@height"/>
                        <xsl:text>;</xsl:text>
                    </xsl:attribute>
                </xsl:if>
            </xsl:element>
            <xsl:text> - </xsl:text>
            <xsl:value-of select="tei:localProp[@name = 'Name']/@value"/>
            <xsl:if test="exists(child::tei:note)">
                <xsl:text> - (</xsl:text>
                <xsl:value-of select="tei:note/text()"/>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:pb[not(exists(parent::tei:quote))]"/>
    
    <xsl:template match="tei:text/tei:body/tei:div/tei:div[@type = 'page-of-Hertz-edition']">
        <div class="page-of-edition">
            <xsl:element name="a">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat(substring-before(root()//tei:prefixDef[@ident = 'images-keil']/@replacementPattern,'$1'),substring-after(current()/@corresp,'images-keil:'))"/>
                </xsl:attribute>
                <xsl:attribute name="target">
                    <xsl:value-of select="'_blank'"/>
                </xsl:attribute>
                <xsl:element name="i">
                    <xsl:attribute name="class" select="'far fa-image'"/>
                </xsl:element>
                <xsl:text> </xsl:text>
                <xsl:text>Picture of Hertz’ edition of Priscian’s Ars Grammatica</xsl:text>
            </xsl:element>
            <p class="main-text-paragraph">
                <xsl:element name="a">
                    <xsl:attribute name="id" select="@xml:id"/>
                </xsl:element>
                <span class="edition-heading-1">
                    <xsl:value-of select="@n"/>
                </span>
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
    
    <xsl:template match="tei:foreign[@xml:lang = 'grc'][parent::tei:quote]">
        <xsl:element name="span">
            <xsl:attribute name="style" select="'font-family: Noto Serif; font-size: 14pt;'"/>
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:foreign[@xml:lang = 'grc'][parent::tei:lem]">
        <xsl:element name="span">
            <xsl:attribute name="style" select="'font-family: Noto Serif; font-size: 14pt;'"/>
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="text()[parent::tei:quote]">
        <span class="bold-text">
            <xsl:value-of select="."/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb[parent::tei:quote]">
        <span class="italic-text">
                <xsl:text> (</xsl:text>
                <xsl:value-of select="@ed"/>
                <xsl:text>,</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>) </xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb[parent::tei:add[parent::tei:quote]]">
        <span class="italic-text">
            <xsl:text> (</xsl:text>
            <xsl:value-of select="@ed"/>
            <xsl:text>,</xsl:text>
            <xsl:value-of select="@n"/>
            <xsl:text>) </xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:if test="not(local-name(following-sibling::*[1]) = 'supplied')">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="for $x in (1 to @quantity) return '.'"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:quote]">
        <span class="bold-text">
            <xsl:text> 〈</xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:if test="exists(@resp)">
                <xsl:text> - </xsl:text>
                <xsl:choose>
                    <xsl:when test="@resp = 'scr-1'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>main scribe</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@resp = 'scr'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>main scribe</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@resp = 'sec'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>secondary scribe</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@resp = 'gl-1'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>first glossator</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@resp = 'gl-2'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>second glossator</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:when test="@resp = 'Otfrid'">
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>Otfrid</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="span">
                            <xsl:attribute name="style" select="'font-style: italic;'"/>
                            <xsl:text>C. G.</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:text>〉</xsl:text>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:supplied[parent::tei:add/parent::tei:rdg]">
         <xsl:text> 〈</xsl:text>
         <xsl:value-of select="text()"/>
        <xsl:if test="exists(@resp)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="@resp = 'scr-1'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>main scribe</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@resp = 'scr'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>main scribe</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@resp = 'sec'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>secondary scribe</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@resp = 'gl-1'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>first glossator</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@resp = 'gl-2'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>second glossator</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:when test="@resp = 'Otfrid'">
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>Otfrid</xsl:text>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="span">
                        <xsl:attribute name="style" select="'font-style: italic;'"/>
                        <xsl:text>C. G.</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:quote]">
        <span class="bold-text referred-word">
            <xsl:value-of select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:quote]">
        <span class="bold-italic-text">
            <xsl:apply-templates/>
        </span>
        <span class="italic-text">
            <xsl:text> (</xsl:text>
            <xsl:if test="exists(child::tei:hi)">
                <xsl:value-of select="child::tei:hi/@rend"/>
            </xsl:if>
            <span class="set-margin-left-and-right"><i class="far fa-hand-paper"></i></span>
            <xsl:if test="(substring-after(@hand,'#') = 'scr-1') or (substring-after(@hand,'#') = 'scr')">
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
        </span>
    </xsl:template>
    
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="(@rend = 'red capitalis') or (@rend = 'red capitalis rustica') or (@rend = 'letter filled with red ink')">
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'color: #9e1b16;'"/>
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:pb">
        <xsl:if test="exists(parent::tei:quote)">
            <span class="bold-text">
                <xsl:text>(</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text>)</xsl:text>
            </span>
        </xsl:if>
        <xsl:if test="not(exists(parent::tei:quote))">
            <p class="main-text-paragraph">
                <span class="bold-text">
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="@n"/>
                    <xsl:text>)</xsl:text>
                </span>
            </p>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'text-variation']">
        <p class="type-of-intervention"><xsl:text>Text variation:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem"/>
            <xsl:apply-templates select="tei:rdg" mode="text-variation"/>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'reference-signs']">
        <p class="type-of-intervention"><xsl:text>Reference sign:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem"/>
            <xsl:apply-templates select="tei:rdg"/>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'emendation']">
        <p class="type-of-intervention"><xsl:text>Emendation:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem"/>
            <xsl:apply-templates select="tei:rdg" mode="emendation"/>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="emendation">
        <div class="apparatus-reading">
            <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:text>Codex 50</xsl:text>
            </xsl:if>
            <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
                <xsl:value-of select="substring-after(@wit,'#')"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates select="child::node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:del[@type = 'expunction']">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'expunction'"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text> </xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:del[not(exists(@type)) or not(@type = 'expunction')]">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'expunction'"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text> </xsl:text>
        </xsl:element>
        <xsl:if test="exists(@hand)">
            <xsl:text>[</xsl:text>
            <span class="set-margin-left-and-right"><i class="far fa-hand-paper"></i></span>
            <xsl:choose>
                <xsl:when test="(substring-after(@hand,'#') = 'scr') or (substring-after(@hand,'#') = 'scr-1')">
                    <xsl:text>main scribe</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'sec'">
                    <xsl:text>secondary scribe</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-1'">
                    <xsl:text>first glossator</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                    <xsl:text>second glossator</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C. G.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg/parent::tei:app[@type = 'emendation']]">
        <xsl:text> 〈</xsl:text>
        <xsl:value-of select="text()"/>
        <xsl:text>〉</xsl:text>
        <xsl:text> [</xsl:text>
        <i class="far fa-compass" style="margin-left: 15pt;"></i>
        <xsl:element name="span">
            <xsl:attribute name="class" select="'emphasize-location'"/>
            <xsl:value-of select="@place"/>
        </xsl:element>
        <xsl:if test="exists(@hand)">
            <span class="set-margin-left-and-right"><i class="far fa-hand-paper"></i></span>
        <!-- <xsl:if test="exists(parent::tei:rdg/@hand)">
            <xsl:if test="(substring-after(parent::tei:rdg/@hand,'#') = 'scr-1') or (substring-after(parent::tei:rdg/@hand,'#') = 'scr')">
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
        </xsl:if> -->
            <xsl:choose>
                <xsl:when test="(substring-after(@hand,'#') = 'scr') or (substring-after(@hand,'#') = 'scr-1')">
                    <xsl:text>main scribe</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'sec'">
                    <xsl:text>secondary scribe</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-1'">
                    <xsl:text>first glossator</xsl:text>
                </xsl:when>
                <xsl:when test="substring-after(@hand,'#') = 'gl-2'">
                    <xsl:text>second glossator</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C. G.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'gloss']">
        <p class="type-of-intervention"><xsl:text>Gloss:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem" mode="gloss-lemma"/>
            <span class="around-link">
            <xsl:element name="a">
                <xsl:attribute name="class" select="'link-for-gloss'"/>
                <xsl:attribute name="href" select="@xml:id"/>
                <xsl:attribute name="id" select="@xml:id"/>
                <i class="fa-solid fa-info"></i>
            </xsl:element>
            </span>
            <xsl:element name="div">
                <xsl:attribute name="class" select="'apparatus-reading apparatus-hidden'"/>
                <xsl:attribute name="id" select="concat('div-for-',@xml:id)"/>
            </xsl:element>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'annotation-signs']">
        <p class="type-of-intervention"><xsl:text>Annotation Sign:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem" mode="gloss-lemma"/>
            <span class="around-link">
                <xsl:element name="a">
                    <xsl:attribute name="class" select="'link-for-annotation-sign'"/>
                    <xsl:attribute name="href" select="@xml:id"/>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <i class="fa-solid fa-info"></i>
                </xsl:element>
            </span>
            <xsl:element name="div">
                <xsl:attribute name="class" select="'apparatus-reading apparatus-hidden'"/>
                <xsl:attribute name="id" select="concat('div-for-',@xml:id)"/>
            </xsl:element>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'rubrication']">
        <p class="type-of-intervention"><xsl:text>Rubrication:</xsl:text></p>
        <div class="apparatus">
            <xsl:apply-templates select="tei:lem"/>
            <xsl:apply-templates select="tei:rdg" mode="rubrication"/>
            <p>
                <xsl:text>Id: </xsl:text>
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'font-family: monospace; font-style: italic; font-size: 12pt;'"/>
                    <xsl:value-of select="@xml:id"/>
                </xsl:element>
            </p>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="rubrication">
        <div class="apparatus-reading">
            <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:text>Codex 50</xsl:text>
            </xsl:if>
            <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
                <xsl:value-of select="substring-after(@wit,'#')"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates select="child::node()"/>
            <xsl:text> [</xsl:text>
            <xsl:value-of select="child::tei:hi/@rend"/>
            <span class="set-margin-left"><i class="far fa-hand-paper"></i></span>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-hand'"/>
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
            </xsl:element>
            <xsl:text>]</xsl:text>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:lem">
        <p class="apparatus-lemma">
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
        </p>
    </xsl:template>
    
    <xsl:template match="tei:lem" mode="gloss-lemma">
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
    </xsl:template>
    
    <xsl:template match="tei:rdg">
        <div class="apparatus-reading">
            <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:text>Codex 50</xsl:text>
            </xsl:if>
            <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
                <xsl:value-of select="substring-after(@wit,'#')"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:if test="not(exists(text())) and not(exists(child::node()))">
                <i>
                <xsl:text>omitted</xsl:text>
                </i>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="exists(child::tei:add/@facs)">
                <span class="around-link">
                    <xsl:element name="a">
                        <xsl:if test="parent::tei:app[@type = 'text-variation']">
                            <xsl:attribute name="class" select="'link-for-text-variation'"/>
                        </xsl:if>
                        <xsl:if test="parent::tei:app[@type = 'reference-signs']">
                            <xsl:attribute name="class" select="'link-for-reference-sign'"/>
                        </xsl:if>
                        <xsl:attribute name="href" select="parent::tei:app/@xml:id"/>
                        <xsl:attribute name="id" select="parent::tei:app/@xml:id"/>
                        <i class="fa-solid fa-info"></i>
                    </xsl:element>
                </span>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="text-variation">
        <div class="apparatus-reading">
            <xsl:if test="substring-after(@wit,'#') = 'COD_50'">
                <xsl:text>Codex 50</xsl:text>
            </xsl:if>
            <xsl:if test="not(substring-after(@wit,'#') = 'COD_50')">
                <xsl:value-of select="substring-after(@wit,'#')"/>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:if test="not(exists(text())) and not(exists(child::node()))">
                <i>
                    <xsl:text>omitted</xsl:text>
                </i>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="(count(child::tei:add) = 1) and (count(child::tei:*[not(local-name(.) = 'add')]) = 0) and exists(child::tei:add/@facs) and not(exists(child::text()))">
                    <xsl:apply-templates select="child::node()" mode="text-variation-reading-complex-content"/>
                    <span class="around-link">
                        <xsl:element name="a">
                            <xsl:attribute name="class" select="'link-for-text-variation'"/>
                            <xsl:attribute name="href" select="parent::tei:app/@xml:id"/>
                            <xsl:attribute name="id" select="parent::tei:app/@xml:id"/>
                            <i class="fa-solid fa-info"></i>
                        </xsl:element>
                    </span>
                </xsl:when>
                <xsl:when test="(count(child::tei:add) = 1) and (count(child::tei:*[not(local-name(.) = 'add')]) = 0) and not(exists(child::tei:add/@facs)) and not(exists(child::text()))">
                    <xsl:apply-templates select="child::node()" mode="text-variation-reading-complex-content-single-add"/>
                </xsl:when>
                <xsl:when test="(count(child::tei:add) = 1) and (count(child::tei:*[not(local-name(.) = 'add')]) = 0) and exists(child::text())"><!-- add and text -->
                    <xsl:apply-templates select="child::node()" mode="text-variation-reading-complex-content"/>
                </xsl:when>
                <xsl:when test="(count(child::tei:add) = 1) and (count(child::tei:*[not(local-name(.) = 'add')]) gt 0)">
                    <xsl:apply-templates select="child::node()" mode="text-variation-reading-complex-content"/>
                </xsl:when>
                <xsl:when test="(count(child::tei:add) gt 1) and (count(child::tei:*[not(local-name(.) = 'add')]) gt 0)">
                    <xsl:apply-templates select="child::node()" mode="text-variation-reading-complex-content"/>
                </xsl:when>
                <xsl:when test="(count(child::tei:add) = 0) and (count(child::tei:*[not(local-name(.) = 'add')]) gt 0)">
                    <xsl:apply-templates select="child::node()"/>
                </xsl:when>
                <xsl:when test="(count(child::tei:*) = 0) and exists(child::text())"><!-- only text content -->
                    <xsl:apply-templates select="child::node()"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="exists(@hand)">
                <xsl:element name="br"/>
                <span class="set-margin-left"><i class="far fa-hand-paper"></i></span>
                <xsl:element name="span">
                    <xsl:attribute name="class" select="'emphasize-hand'"/>
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
                </xsl:element>
            </xsl:if>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:w" mode="text-variation-reading-complex-content">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="text-variation-reading-complex-content">
        <xsl:text>/</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="exists(@hand)">
            <i class="far fa-hand-paper" style="margin-left: 15pt;"></i>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-hand'"/>
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
            </xsl:element>
        </xsl:if>
        <xsl:if test="exists(@place)">
            <i class="far fa-compass" style="margin-left: 15pt;"></i>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-location'"/>
                <xsl:value-of select="@place"/>
            </xsl:element>
        </xsl:if>
        <xsl:if test="exists(@ana)">
            <xsl:for-each select="tokenize(@ana,'\s*#')">
                <xsl:if test=". != ''">
                    <i class="fas fa-glasses" style="margin-left: 15pt;"></i>
                    <span class="emphasize-analysis">
                        <!-- <xsl:value-of select="$root-node//tei:category[@xml:id = current()]/tei:catDesc/text()"/> -->
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
                    </span>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>/</xsl:text>
        <xsl:if test="exists(@facs)">
            <span class="around-link">
                <xsl:element name="a">
                    <xsl:attribute name="class" select="'link-for-text-variation'"/>
                    <xsl:attribute name="href" select="ancestor::tei:app/@xml:id"/>
                    <xsl:attribute name="id" select="ancestor::tei:app/@xml:id"/>
                    <i class="fa-solid fa-info"></i>
                </xsl:element>
            </span>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:add" mode="text-variation-reading-complex-content-single-add">
        <xsl:apply-templates select="child::node()"/>
        <xsl:if test="exists(@hand)">
            <xsl:element name="br"/>
            <span class="set-margin-left"><i class="far fa-hand-paper"></i></span>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-hand'"/>
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
            </xsl:element>
        </xsl:if>
        <xsl:if test="exists(@place)">
            <xsl:element name="br"/>
            <span class="set-margin-left"><i class="far fa-compass"></i></span>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-location'"/>
                <xsl:value-of select="@place"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:hi" mode="text-variation-reading-complex-content">
        <xsl:choose>
            <xsl:when test="(@rend = 'red capitalis') or (@rend = 'red capitalis rustica') or (@rend = 'letter filled with red ink')">
                <xsl:element name="span">
                    <xsl:attribute name="style" select="'color: #9e1b16;'"/>
                    <xsl:value-of select="text()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:reg" mode="text-variation-reading-complex-content">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="text-variation-reading-complex-content">
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>| </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del" mode="text-variation-reading-complex-content">
        <xsl:element name="span">
            <xsl:attribute name="class" select="'expunction'"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="text()"/>
            <xsl:text> </xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:foreign[@xml:lang = 'grc']" mode="text-variation-reading-complex-content">
        <xsl:element name="span">
            <xsl:attribute name="style" select="'font-family: Noto Serif; font-size: 14pt;'"/>
            <xsl:apply-templates select="child::node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:foreign[not(@xml:lang = 'grc')]" mode="text-variation-reading-complex-content">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="text-variation-reading-complex-content">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg and not(parent::tei:rdg/parent::tei:app[@type = 'emendation'])]">
        <xsl:apply-templates/>
        <xsl:element name="br"/>
        <span class="set-margin-left"><i class="far fa-compass"></i></span>
        <xsl:element name="span">
            <xsl:attribute name="class" select="'emphasize-location'"/>
            <xsl:value-of select="@place"/>
        </xsl:element>
        <xsl:element name="br"/>
        <span class="set-margin-left"><i class="far fa-hand-paper"></i></span>
        <xsl:element name="span">
            <xsl:attribute name="class" select="'emphasize-hand'"/>
            <xsl:if test="(substring-after(@hand,'#') = 'scr-1') or (substring-after(@hand,'#') = 'scr')">
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
        </xsl:element>
        <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
        <xsl:if test="exists(@ana)">
            <xsl:for-each select="tokenize(@ana,'\s*#')">
                <xsl:if test=". != ''">
                    <xsl:element name="br"/>
                    <span class="set-margin-left"><i class="fas fa-glasses"></i></span>
                    <span class="emphasize-analysis">
                        <!-- <xsl:value-of select="$root-node//tei:category[@xml:id = current()]/tei:catDesc/text()"/> -->
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
                    </span>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:g">
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>| </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:w[parent::tei:rdg]">
        <span class="referred-word">
            <xsl:value-of select="text()"/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:note[@type = 'explanation']">
        <p class="type-of-intervention"><xsl:text>Explanation:</xsl:text></p>
        <div class="note">
            <span class="set-margin-left-and-right"><i class="far fa-comment"></i></span>
            <xsl:text>On </xsl:text>
            <xsl:if test="exists(@target)">
                <xsl:if test="contains(@target,' ')">
                    <xsl:for-each select="tokenize(@target,' ')">
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="'typewriter'"/>
                            <xsl:value-of select="substring-after(.,'#')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="not(contains(@target,' '))">
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="'typewriter'"/>
                        <xsl:value-of select="substring-after(@target,'#')"/>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:if test="not(exists(@target))">
                <xsl:if test="contains(@corresp,' ')">
                    <xsl:for-each select="tokenize(@corresp,' ')">
                        <xsl:element name="span">
                            <xsl:attribute name="class" select="'typewriter'"/>
                            <xsl:value-of select="substring-after(.,'#')"/>
                            <xsl:if test="position() != last()">
                                <xsl:text>, </xsl:text>
                            </xsl:if>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:if>
                <xsl:if test="not(contains(@corresp,' '))">
                    <xsl:element name="span">
                        <xsl:attribute name="class" select="'typewriter'"/>
                        <xsl:value-of select="substring-after(@corresp,'#')"/>
                    </xsl:element>
                </xsl:if>
            </xsl:if>
            <xsl:text>: </xsl:text>
            <xsl:apply-templates select="child::node()"/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:note[@type = 'gloss']">
        <p class="type-of-intervention">
            <xsl:text>Note:</xsl:text>
            <span class="around-link">
                <xsl:element name="a">
                    <xsl:attribute name="class" select="'link-for-note'"/>
                    <xsl:attribute name="href" select="@xml:id"/>
                    <xsl:attribute name="id" select="@xml:id"/>
                    <i class="fa-solid fa-info"></i>
                </xsl:element>
            </span>
        </p>
        <div class="note">
            <span class="set-margin-left-and-right"><i class="far fa-comment"></i></span>
            <xsl:apply-templates/>
            <xsl:element name="br"/>
            <span class="set-margin-left"><i class="far fa-compass"></i></span>
            <span class="emphasize-location">
                <xsl:value-of select="@place"/>
            </span>
            <xsl:element name="br"/>
            <span class="set-margin-left"><i class="far fa-hand-paper"></i></span>
            <xsl:element name="span">
                <xsl:attribute name="class" select="'emphasize-hand'"/>
                <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                    <xsl:text>main scribe</xsl:text>
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
                <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:if>
            </xsl:element>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:ptr">
        <p class="pointer">
            <xsl:value-of select="parent::tei:rdg/parent::tei:app/tei:lem/text()"/>
            <xsl:text> &#8594; </xsl:text>
            <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
            <xsl:for-each select="tokenize(@target,'\s')">
                <span class="pointer-targets">
                    <xsl:value-of select="$root-node//tei:w[@xml:id = substring-after(current(),'#')]/text()"/>
                </span>
                <xsl:text> </xsl:text>
                <span class="pointer-target-source">
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
                </span>
            </xsl:for-each>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:choice[parent::tei:add]">
        <xsl:if test="exists(tei:abbr/tei:hi[@rend = 'overline'])">
            <span style="text-decoration: overline;">
                <xsl:value-of select="tei:abbr/tei:hi/text()"/>
            </span>
        </xsl:if>
        <xsl:if test="not(exists(tei:abbr/tei:hi[@rend = 'overline']))">
            <xsl:value-of select="tei:abbr/text()"/>
        </xsl:if>
        <xsl:text> (</xsl:text>
            <xsl:value-of select="tei:expan/text()"/>
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:app[(@type = 'text-variation') and exists(child::tei:rdg/child::tei:add/@facs)]" mode="text-variations-as-json">
        <xsl:text>{ "id" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>" : { </xsl:text>
            <xsl:text>"zone" : { </xsl:text>
                <xsl:text> "ulx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@ulx"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "uly" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@uly"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "lrx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@lrx"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "lry" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@lry"/>
                <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        <xsl:text> "page-url" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/parent::tei:surface/tei:graphic/@url"/>
        <xsl:text>", "index" : "</xsl:text>
        <xsl:apply-templates select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/parent::tei:surface/tei:graphic" mode="indizes"/>
        <xsl:text>"</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
     </xsl:template>
    
    <xsl:template match="tei:app[(@type = 'reference-signs') and exists(child::tei:rdg/child::tei:add/@facs)]" mode="reference-signs-as-json">
        <xsl:text>{ "id" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>" : { </xsl:text>
            <xsl:text>"zone" : { </xsl:text>
                <xsl:text> "ulx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@ulx"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "uly" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@uly"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "lrx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@lrx"/>
                <xsl:text>",</xsl:text>
                <xsl:text> "lry" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/@lry"/>
                <xsl:text>"</xsl:text>
            <xsl:text> },</xsl:text>
        <xsl:text> "page-url" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/parent::tei:surface/tei:graphic/@url"/>
        <xsl:text>", "index" : "</xsl:text>
        <xsl:apply-templates select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/child::tei:rdg/child::tei:add/@facs,'#')]/parent::tei:surface/tei:graphic" mode="indizes"/>
        <xsl:text>"</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:note[exists(@facs)]" mode="notes-as-json">
        <xsl:text>{ "id" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>" : { </xsl:text>
        <xsl:text>"zone" : { </xsl:text>
        <xsl:text> "ulx" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@ulx"/>
        <xsl:text>",</xsl:text>
        <xsl:text> "uly" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@uly"/>
        <xsl:text>",</xsl:text>
        <xsl:text> "lrx" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@lrx"/>
        <xsl:text>",</xsl:text>
        <xsl:text> "lry" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@lry"/>
        <xsl:text>"</xsl:text>
        <xsl:text> },</xsl:text>
        <xsl:text> "page-url" : "</xsl:text>
        <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/parent::tei:surface/tei:graphic/@url"/>
        <xsl:text>", "index" : "</xsl:text>
        <xsl:apply-templates select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/parent::tei:surface/tei:graphic" mode="indizes"/>
        <xsl:text>"</xsl:text>
        <xsl:text>}}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'gloss']" mode="glosses-as-json">
        <xsl:text>{ "id" : "</xsl:text>
            <xsl:value-of select="@xml:id"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="glosses-as-json"/>
        <xsl:text>}}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:app[@type = 'annotation-signs']" mode="annotation-signs-as-json">
        <xsl:text>{ "id" : "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>", "</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>" : {</xsl:text>
        <xsl:apply-templates select="child::tei:rdg" mode="glosses-as-json"/>
        <xsl:text>}}</xsl:text>
        <xsl:if test="position() != last()">
            <xsl:text>,</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:rdg" mode="glosses-as-json">
        <xsl:text> "reading" : {</xsl:text>
            <xsl:text> "witness" : "</xsl:text>
                <xsl:if test="@wit = '#COD_50'">
                    <xsl:text>Codex 50</xsl:text>
                </xsl:if>
                <xsl:if test="@wit != '#COD_50'">
                    <xsl:value-of select="substring-after(@wit,'#')"/>
                </xsl:if>
            <xsl:text>",</xsl:text>
            <xsl:apply-templates select="tei:add" mode="glosses-as-json"/>
        <xsl:text>}</xsl:text>
        <xsl:if test="exists(following-sibling::tei:note[1])">
            <xsl:text>, "note" : "</xsl:text>
            <xsl:apply-templates select="following-sibling::tei:note[1]" mode="glosses-as-json"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
        <xsl:if test="exists(tei:ptr)">
            <xsl:text>, "pointer" : "</xsl:text>
            <xsl:apply-templates select="tei:ptr" mode="glosses-as-json"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <!-- <xsl:template match="tei:note" mode="glosses-as-json">
        <xsl:value-of select="replace(normalize-space(text()),'(&quot;)','\\$1')"/>
    </xsl:template> -->
    
    <xsl:template match="tei:note" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()" mode="note-content"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'italic']" mode="note-content">
        <xsl:apply-templates select="child::node()" mode="note-content"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'bold']" mode="note-content">
        <xsl:apply-templates select="child::node()" mode="note-content"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="note-content">
        <xsl:choose>
            <xsl:when test="contains(.,'&#xA;')">
                <xsl:if test="starts-with(.,' ')">
                    <xsl:value-of select="concat(' ',normalize-space(translate(.,'&#xA;','')))"/>
                </xsl:if>
                <xsl:if test="not(starts-with(.,' '))">
                    <xsl:value-of select="normalize-space(translate(.,'&#xA;',''))"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="not(contains(.,'&#xA;'))">
                <xsl:value-of select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:ptr" mode="glosses-as-json">
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
            <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
            </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:rdg]" mode="glosses-as-json">
        <xsl:text> "place" : "</xsl:text>
            <xsl:value-of select="@place"/>
        <xsl:text>",</xsl:text>
        <xsl:text> "hand" : "</xsl:text>
            <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                <xsl:text>main scribe</xsl:text>
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
            <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
        <xsl:text>",</xsl:text>
        <xsl:text> "text" : "</xsl:text>
            <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
        <xsl:text>",</xsl:text>
        <xsl:text> "analysis" : [</xsl:text>
            <xsl:variable name="root-node" select="root()/tei:TEI" as="node()"/>
            <xsl:for-each select="tokenize(@ana,'\s*#')">
                <xsl:if test=". != ''">
                    <xsl:text>"</xsl:text>
                        <!-- <xsl:value-of select="normalize-space($root-node//tei:category[@xml:id = current()]/tei:catDesc/text())"/> -->
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
                    <xsl:text>"</xsl:text>
                    <xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if>
                </xsl:if>
            </xsl:for-each>
        <xsl:text>],</xsl:text>
        <xsl:text> "zone" : {</xsl:text>
            <xsl:text> "ulx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@ulx"/>
            <xsl:text>",</xsl:text>
            <xsl:text> "uly" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@uly"/>
            <xsl:text>",</xsl:text>
            <xsl:text> "lrx" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@lrx"/>
            <xsl:text>",</xsl:text>
            <xsl:text> "lry" : "</xsl:text>
                <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/@lry"/>
            <xsl:text>"</xsl:text>
        <xsl:text>},</xsl:text>
        <xsl:text> "page-url" : "</xsl:text>
            <xsl:value-of select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/parent::tei:surface/tei:graphic/@url"/>
        <xsl:text>", "index" : "</xsl:text>
        <xsl:apply-templates select="root()/tei:TEI/tei:facsimile/tei:surface/tei:zone[@xml:id = substring-after(current()/@facs,'#')]/parent::tei:surface/tei:graphic" mode="indizes"/>
        <xsl:text>"</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:surface/tei:graphic" mode="indizes">
        <xsl:number select="." count="root()//tei:surface/tei:graphic" level="any"/>
    </xsl:template>
    
    <xsl:template match="tei:del[@type = 'expunction']" mode="glosses-as-json">
        <xsl:text>[</xsl:text>
            <xsl:value-of select="text()"/>
        <xsl:if test="exists(@resp)">
            <xsl:text> - expunction by </xsl:text>
            <xsl:if test="substring-after(@resp,'#') = 'scr-1' or substring-after(@resp,'#') = 'scr'">
                <xsl:text>main scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@resp,'#') = 'sec'">
                <xsl:text>secondary scribe</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@resp,'#') = 'gl-1'">
                <xsl:text>first glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@resp,'#') = 'gl-2'">
                <xsl:text>second glossator</xsl:text>
            </xsl:if>
            <xsl:if test="substring-after(@resp,'#') = 'Otfrid'">
                <xsl:text>Otfrid</xsl:text>
            </xsl:if>
        </xsl:if>
        <xsl:text>]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:del[not(exists(@type))]" mode="glosses-as-json">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates select="child::node()"/>
        <xsl:text> - deleted]</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:add[parent::tei:add]" mode="glosses-as-json">
        <xsl:text>〈</xsl:text>
            <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
        <xsl:if test="exists(@resp) or exists(@hand)">
            <xsl:text> - added by </xsl:text>
            <xsl:if test="exists(@resp)">
                <xsl:if test="substring-after(@resp,'#') = 'scr-1' or substring-after(@resp,'#') = 'scr'">
                    <xsl:text>main scribe</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@resp,'#') = 'sec'">
                    <xsl:text>secondary scribe</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@resp,'#') = 'gl-1'">
                    <xsl:text>first glossator</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@resp,'#') = 'gl-2'">
                    <xsl:text>second glossator</xsl:text>
                </xsl:if>
                <xsl:if test="substring-after(@resp,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:if test="not(exists(@resp)) and exists(@hand)">
                <xsl:if test="substring-after(@hand,'#') = 'scr-1' or substring-after(@hand,'#') = 'scr'">
                    <xsl:text>main scribe</xsl:text>
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
                <xsl:if test="substring-after(@hand,'#') = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:if>
            </xsl:if>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:gap" mode="glosses-as-json">
        <xsl:if test="not(local-name(following-sibling::*[1]) = 'supplied')">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="for $x in (1 to @quantity) return '.'"/>
            <xsl:text>]</xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:supplied" mode="glosses-as-json">
        <xsl:text>〈</xsl:text>
            <xsl:apply-templates select="child::node()"/>
        <xsl:if test="exists(@resp)">
            <xsl:text> - </xsl:text>
            <xsl:choose>
                <xsl:when test="@resp = 'scr-1'">
                    <xsl:text>main scribe</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'scr'">
                    <xsl:text>main scribe</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'sec'">
                    <xsl:text>secondary scribe</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-1'">
                    <xsl:text>first glossator</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'gl-2'">
                    <xsl:text>second glossator</xsl:text>
                </xsl:when>
                <xsl:when test="@resp = 'Otfrid'">
                    <xsl:text>Otfrid</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>C. G.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <xsl:text>〉</xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:g" mode="glosses-as-json">
        <xsl:text>|</xsl:text>
        <xsl:value-of select="root()//tei:glyph[@xml:id = substring-after(current()/@ref,'#')]/tei:localProp[@name = 'Name']/@value"/>
        <xsl:text>| </xsl:text>
    </xsl:template>
    
    <xsl:template match="tei:foreign" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()"/>
    </xsl:template>
    
    <xsl:template match="tei:choice" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
    </xsl:template>
    
    <xsl:template match="tei:abbr[parent::tei:choice]" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'overline'][parent::tei:abbr]" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'red script'][parent::tei:add]" mode="glosses-as-json">
        <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
    </xsl:template>
    
    <xsl:template match="tei:expan[parent::tei:choice]" mode="glosses-as-json">
        <xsl:text> (</xsl:text>
        <xsl:apply-templates select="child::node()" mode="glosses-as-json"/>
        <xsl:text>) </xsl:text>
    </xsl:template>
    
    <xsl:template match="text()" mode="glosses-as-json">
        <xsl:choose>
            <xsl:when test="contains(.,'&#xA;')">
                <xsl:if test="starts-with(.,' ')">
                    <xsl:value-of select="concat(' ',normalize-space(translate(.,'&#xA;','')))"/>
                </xsl:if>
                <xsl:if test="not(starts-with(.,' '))">
                    <xsl:value-of select="normalize-space(translate(.,'&#xA;',''))"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="not(contains(.,'&#xA;'))">
                <xsl:value-of select="."/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>