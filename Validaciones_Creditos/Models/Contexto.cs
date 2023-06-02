﻿using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace Validaciones_Creditos.Models;

public partial class Contexto : DbContext
{
    public Contexto()
    {
    }

    public Contexto(DbContextOptions<Contexto> options)
        : base(options)
    {
    }

    public virtual DbSet<ValidarUsuario> ValidarUsuarios { get; set; }
    public virtual DbSet<TablaCreditosInstituto> TablaCreditos { get; set; }
    public virtual DbSet<TotalCreditosUser> TotalCreditosUsuarios { get; set; }
    public virtual DbSet<FiltroEvento> FiltroEventos { get; set; }
    public virtual DbSet<EventosInfoPost> InfoEventosPost { get; set; }

    public virtual DbSet<Evento> Eventos { get; set; }

    public virtual DbSet<EventosRealizado> EventosRealizados { get; set; }

    public virtual DbSet<TipoCertificado> TipoCertificados { get; set; }

    public virtual DbSet<Usuario> Usuarios { get; set; }


    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=.\\SQLEXPRESS;Database=Creditos;User Id= Creditos; password=creditos123;Trusted_Connection=True;TrustServerCertificate = true");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {

        modelBuilder.Entity<Evento>(entity =>
        {
            entity.HasKey(e => e.IdEvento).HasName("PK__Eventos__C8DC7BDAEADDE2FA");

            entity.Property(e => e.IdEvento).HasColumnName("idEvento");
            entity.Property(e => e.Creditos).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Descripcion)
                .HasMaxLength(150)
                .IsUnicode(false);
            entity.Property(e => e.Estado)
                .HasMaxLength(20)
                .IsUnicode(false);
            entity.Property(e => e.Fecha).HasColumnType("datetime");
            entity.Property(e => e.IdTipo).HasColumnName("idTipo");
            entity.Property(e => e.Institucion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Mapa)
                .HasMaxLength(100)
                .IsUnicode(false);
            entity.Property(e => e.Nombre)
                .HasMaxLength(50)
                .IsUnicode(false);
        });

        modelBuilder.Entity<EventosRealizado>(entity =>
        {
            entity.HasNoKey();

            entity.Property(e => e.IdEvento).HasColumnName("idEvento");
            entity.Property(e => e.NumUsuario)
                .HasMaxLength(10)
                .IsUnicode(false);

            entity.HasOne(d => d.IdEventoNavigation).WithMany()
                .HasForeignKey(d => d.IdEvento)
                .HasConstraintName("FK__EventosRe__idEve__5F7E2DAC");

            entity.HasOne(d => d.NumUsuarioNavigation).WithMany()
                .HasForeignKey(d => d.NumUsuario)
                .HasConstraintName("FK__EventosRe__NumUs__607251E5");
        });

        modelBuilder.Entity<TipoCertificado>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("PK__TipoCert__3214EC072C71E7F7");

            entity.ToTable("TipoCertificado");

            entity.Property(e => e.CreditosMax).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.CreditosValor).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Institucion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.NombreTc)
                .HasMaxLength(150)
                .IsUnicode(false)
                .HasColumnName("NombreTC");
        });

        modelBuilder.Entity<Usuario>(entity =>
        {
            entity.HasKey(e => e.NumeroCuenta).HasName("PK__Usuarios__E039507A9305CB2A");

            entity.Property(e => e.NumeroCuenta)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Apellidos)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.CreditosTotales).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Institucion)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Nip)
                .HasMaxLength(10)
                .IsUnicode(false);
            entity.Property(e => e.Nombre)
                .HasMaxLength(50)
                .IsUnicode(false);
            entity.Property(e => e.Rol)
                .HasMaxLength(20)
                .IsUnicode(false);
        });


        modelBuilder.Entity<EventosInfoPost>().HasNoKey();

        OnModelCreatingPartial(modelBuilder);
    }
    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}