<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
                xmlns:xlink="http://www.w3.org/1999/xlink" >
    <xsl:output method="text" />

    <!-- Find the title style -->
    <xsl:variable name="titleStyle">
        <xsl:value-of select="descendant::style:style[@style:parent-style-name='Title']/@style:name" />
    </xsl:variable>

    <xsl:template match="/">
        <xsl:apply-templates select="office:document-content/office:body/office:text" />
   </xsl:template>

<xsl:template match="text:p[@text:style-name=$titleStyle]">
<!-- Traps heading 1 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','=========================================================')"/>
    <xsl:call-template name="newline" />
</xsl:template>

<xsl:template match="text:p[@text:style-name='Heading_20_1']">
<!-- Traps heading 2 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','---------------------------------------------------------')"/>
    <xsl:call-template name="newline" />
</xsl:template>

<xsl:template match="text:p[@text:style-name='Heading_20_2']">
<!-- Traps heading 3 -->
    <xsl:variable name="underline" select="." />
    <xsl:value-of select="."/>
    <xsl:value-of select="translate($underline,'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz -','~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~')"/>
    <xsl:call-template name="newline" />
</xsl:template>

<xsl:template match="text:list-item">
    <xsl:text>#. </xsl:text> 
<xsl:apply-templates />
</xsl:template>

<xsl:template match="text:p">
<!-- Traps body paragraph -->
    <xsl:apply-templates />
    <xsl:call-template name="newline" />
</xsl:template>


<!-- Traps boldface -->
<xsl:template match="text:span[@text:style-name='T12' or @text:style-name='T9' or @text:style-name='T2']">
  <xsl:value-of select="concat('**',.,'**')" />
</xsl:template>

<xsl:template match="text:span">
<!-- Traps body text -->
    <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="text:a[@xlink:type='simple']">
<!-- Creates an rSt hyperlink `Label <url>`_ 
     &#96; is a backtick
     &lt; is bracket-open
     &gt; is bracket-close
-->
     <xsl:value-of select="concat('&#96;',text:span,' &lt;',@xlink:href,'&gt;&#96;_')"/>
</xsl:template>


<!-- Nodes to ignore -->
<xsl:template match="text:sequence-decls|text:bookmark|text:p[@text:style-name='P1']|draw:frame|text:line-break|text:tab" />

<!-- Suppresses newline after each node. -->
<xsl:template match="text()" />

<xsl:template name="newline">
    <xsl:text>&#xA;&#xA;</xsl:text>
</xsl:template>


</xsl:stylesheet>

<!--  saxon -s:source.xml  -xsl:stylesheet.xsl -o:output.rst -->
<!--  saxon  -s:/tmp/barf/content.xml  -xsl:transform.xsl -->