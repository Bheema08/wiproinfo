// DTOs/BlogPostDto.cs
using System.ComponentModel.DataAnnotations;

namespace BlogCMS.DTOs
{
    public class BlogPostDto
    {
        public int Id { get; set; }

        [Required]
        [MaxLength(255)]
        public string Title { get; set; }

        [Required]
        public string Content { get; set; }

        [MaxLength(500)]
        public string Excerpt { get; set; }

        [Required]
        [MaxLength(255)]
        public string Slug { get; set; }

        [MaxLength(500)]
        public string FeaturedImageUrl { get; set; }

        [Required]
        [MaxLength(20)]
        public string Status { get; set; } = "Draft";

        [MaxLength(255)]
        public string MetaTitle { get; set; }

        [MaxLength(500)]
        public string MetaDescription { get; set; }

        [MaxLength(500)]
        public string Tags { get; set; }

        public List<int> CategoryIds { get; set; } = new List<int>();
    }
}