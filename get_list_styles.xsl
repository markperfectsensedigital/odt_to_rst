<?xml version="1.0" encoding="UTF-8"?>

<!--  saxon -s:source.xml  -xsl:stylesheet.xsl -o:output.rst -->
<!--  saxon  -s:/tmp/barf/content.xml  -xsl:transform.xsl -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
                xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" 
                xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0"
                xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0" 
                xmlns:fo="urn:oasis:names:tc:opendocument:xmlns:xsl-fo-compatible:1.0" 
                xmlns:xlink="http://www.w3.org/1999/xlink" >
    <xsl:output method="text" />
    <xsl:strip-space elements="*" />


    <xsl:template match="/">
        <xsl:apply-templates select="descendant::text:list-style" />
   </xsl:template>

    <xsl:template match="text:list-style">
        <xsl:if test="child::*[1]/name() = 'text:list-level-style-number'">
            <xsl:value-of select="@style:name" />
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
