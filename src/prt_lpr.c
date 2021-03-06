/*
 * Printer interface for popen() / lpr systems.
 * Copyright (c) 1995-1999 Markku Rossi.
 *
 * Author: Markku Rossi <mtr@iki.fi>
 */

/*
 * This file is part of GNU Enscript.
 *
 * Enscript is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Enscript is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Enscript.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "gsint.h"

/*
 * Global functions.
 */

FILE *
printer_open(char *cmd, char *options, char *queue_param, char *printer_name,
	     void **context_return)
{
  Buffer pipe_cmd;
  FILE *fp;

  buffer_init(&pipe_cmd);

  buffer_append(&pipe_cmd, cmd);
  buffer_append(&pipe_cmd, " ");

  if (options)
    {
      buffer_append(&pipe_cmd, options);
      buffer_append(&pipe_cmd, " ");
    }

  if (printer_name)
    {
      buffer_append(&pipe_cmd, queue_param);
      buffer_append(&pipe_cmd, printer_name);
    }

  fp = popen(buffer_ptr(&pipe_cmd), "w");

  buffer_uninit(&pipe_cmd);

  *context_return = fp;
  return fp;
}


void
printer_close(void *context)
{
  FILE *fp = (FILE *) context;

  pclose(fp);
}
