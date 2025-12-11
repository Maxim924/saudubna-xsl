<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:yandex="http://news.yandex.ru"
    xmlns:turbo="http://news.yandex.ru"
    exclude-result-prefixes="yandex turbo">

  <!-- Результат — HTML -->
  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <!-- Главный шаблон -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="utf-8"/>
        <title>
          <xsl:value-of select="rss/channel/title"/>
        </title>

        <!-- Простая, но аккуратная стилизация -->
        <style type="text/css">
          body{
            font-family: Arial, Helvetica, sans-serif;
            background:#f6f7fb;
            color:#222;
            margin:18px;
          }
          .channel-header{
            display:flex;
            align-items:center;
            gap:12px;
            margin-bottom:20px;
          }
          .logo{width:64px;height:64px;border-radius:6px;}
          h1.site-title{font-size:20px;margin:0;}
          .items{display:flex;flex-direction:column;gap:18px;}
          .item{
            background:#fff;border-radius:8px;padding:16px;
            box-shadow:0 1px 4px rgba(20,30,40,0.06);
            overflow:hidden;
          }
          .meta{font-size:13px;color:#666;margin-bottom:8px;}
          .headline{display:flex;gap:16px;align-items:flex-start;}
          .thumb{flex:0 0 240px;max-width:240px;}
          .thumb img{width:100%;height:auto;border-radius:6px;}
          .title a{color:#0b62c9;text-decoration:none;font-size:18px;font-weight:700;}
          .title a:hover{text-decoration:underline;}
          .fulltext{margin-top:12px;line-height:1.5;color:#222;}
          .related{margin-top:14px;border-top:1px dashed #eee;padding-top:12px;display:flex;flex-wrap:wrap;gap:10px;}
          .rel{display:flex;gap:8px;align-items:center;width:320px;}
          .rel img{width:78px;height:57px;object-fit:cover;border-radius:4px;}
          .rel a{font-size:13px;color:#0b62c9;text-decoration:none;}
          .rel a:hover{text-decoration:underline;}
          .category{display:inline-block;background:#eef6ff;color:#0b62c9;padding:4px 8px;border-radius:12px;font-size:12px;margin-right:8px;}
        </style>
      </head>
      <body>
        <div class="channel-header">
          <xsl:if test="rss/channel/yandex:logo">
            <img class="logo" alt="logo" src="{rss/channel/yandex:logo}"/>
          </xsl:if>
          <div>
            <h1 class="site-title"><xsl:value-of select="rss/channel/title"/></h1>
            <div style="color:#666;font-size:13px;">
              <xsl:value-of select="rss/channel/description"/>
              <xsl:text> — источник: </xsl:text>
              <a href="{rss/channel/link}" style="color:#0b62c9;text-decoration:none;">
                <xsl:value-of select="rss/channel/link"/>
              </a>
            </div>
          </div>
        </div>

        <div class="items">
          <!-- Перебираем элементы -->
          <xsl:for-each select="rss/channel/item">
            <div class="item">
              <!-- Верхняя мета-информация -->
              <div class="meta">
                <span class="category">
                  <xsl:value-of select="category"/>
                </span>
                <span>
                  <xsl:value-of select="normalize-space(pubDate)"/>
                </span>
              </div>

              <div class="headline">
                <!-- Левый блок — изображение (если есть) -->
                <xsl:if test="enclosure[@url]">
                  <div class="thumb">
                    <a href="{link}" target="_blank" rel="noopener">
                      <img alt="{title}" src="{enclosure/@url}"/>
                    </a>
                  </div>
                </xsl:if>

                <!-- Правый блок — заголовок и текст -->
                <div style="flex:1;">
                  <div class="title">
                    <a href="{link}" target="_blank" rel="noopener">
                      <xsl:value-of select="title"/>
                    </a>
                  </div>

                  <!-- Короткое описание -->
                  <div style="margin-top:6px;color:#444;">
                    <xsl:value-of select="normalize-space(description)"/>
                  </div>

                  <!-- Полный текст: предпочитаем turbo:content (в нем HTML), затем yandex:full-text -->
                  <div class="fulltext">
                    <xsl:choose>
                      <xsl:when test="turbo:content">
                        <!-- turbo:content обычно обёрнут в CDATA с HTML — попытка вывести его с обработкой как HTML -->
                        <xsl:value-of select="turbo:content" disable-output-escaping="yes"/>
                      </xsl:when>
                      <xsl:when test="yandex:full-text">
                        <xsl:value-of select="yandex:full-text" disable-output-escaping="yes"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <!-- fallback — выводим description -->
                        <xsl:value-of select="description"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </div>

                  <!-- Сопутствующие материалы (yandex:related) -->
                  <xsl:if test="yandex:related">
                    <div class="related">
                      <xsl:for-each select="yandex:related/link">
                        <div class="rel">
                          <a href="{@url}" target="_blank" rel="noopener">
                            <xsl:if test="@img">
                              <img alt="{normalize-space(.)}" src="{@img}"/>
                            </xsl:if>
                          </a>
                          <div>
                            <a href="{@url}" target="_blank" rel="noopener">
                              <xsl:value-of select="normalize-space(.)"/>
                            </a>
                          </div>
                        </div>
                      </xsl:for-each>
                    </div>
                  </xsl:if>

                </div>
              </div>
            </div>
          </xsl:for-each>
        </div>

      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
